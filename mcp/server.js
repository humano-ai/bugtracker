import http from 'node:http';

const PORT = Number(process.env.PORT || 8080);
const OWNER = process.env.GITHUB_OWNER || 'humano-ai';
const REPO = process.env.GITHUB_REPO || 'bugtracker';
const BRANCH = process.env.GITHUB_BRANCH || 'main';
const GH_TOKEN = process.env.GITHUB_TOKEN || process.env.GH_TOKEN || '';
const API_KEY = process.env.MCP_API_KEY || '';
const SITE_URL = process.env.SITE_URL || 'https://humano-ai.github.io/bugtracker/';

const tools = [
  { name: 'list_tickets', description: 'List Humano cross-project tickets with optional filters.', inputSchema: { type: 'object', properties: { state: { type: 'string' }, project: { type: 'string' }, assignee: { type: 'string' } } } },
  { name: 'get_ticket', description: 'Get a ticket by number.', inputSchema: { type: 'object', required: ['number'], properties: { number: { type: 'number' } } } },
  { name: 'create_ticket', description: 'Create a ticket.', inputSchema: { type: 'object', required: ['title','body'], properties: { title: { type: 'string' }, body: { type: 'string' }, project: { type: 'string' }, assignee: { type: 'string' }, author: { type: 'string' } } } },
  { name: 'update_ticket', description: 'Update ticket metadata/body.', inputSchema: { type: 'object', required: ['number'], properties: { number: { type: 'number' }, title: { type: 'string' }, body: { type: 'string' }, state: { type: 'string' }, project: { type: 'string' }, assignee: { type: 'string' } } } },
  { name: 'close_ticket', description: 'Close a ticket.', inputSchema: { type: 'object', required: ['number'], properties: { number: { type: 'number' } } } },
  { name: 'list_projects', description: 'List projects.', inputSchema: { type: 'object', properties: {} } },
  { name: 'list_assignees', description: 'List assignees.', inputSchema: { type: 'object', properties: {} } }
];

function json(res, code, data) { res.writeHead(code, {'content-type':'application/json; charset=utf-8'}); res.end(JSON.stringify(data)); }
function textContent(x) { return [{ type: 'text', text: typeof x === 'string' ? x : JSON.stringify(x, null, 2) }]; }
function checkAuth(req) { return !API_KEY || req.headers.authorization === `Bearer ${API_KEY}` || req.headers['x-api-key'] === API_KEY; }
function dateRfc() { return new Date().toUTCString().replace('GMT', '+0000'); }
function b64(s) { return Buffer.from(s, 'utf8').toString('base64'); }
function unb64(s) { return Buffer.from(s || '', 'base64').toString('utf8'); }

async function gh(path, opts={}) {
  if (!GH_TOKEN) throw new Error('GITHUB_TOKEN/GH_TOKEN is not configured');
  const r = await fetch(`https://api.github.com/repos/${OWNER}/${REPO}${path}`, { ...opts, headers: { 'accept':'application/vnd.github+json', 'authorization':`Bearer ${GH_TOKEN}`, 'x-github-api-version':'2022-11-28', ...(opts.headers||{}) } });
  const body = await r.text();
  let data; try { data = body ? JSON.parse(body) : null; } catch { data = body; }
  if (!r.ok) throw new Error(`GitHub ${r.status}: ${JSON.stringify(data)}`);
  return data;
}
async function getFile(path) { const d = await gh(`/contents/${path}?ref=${BRANCH}`); return { sha: d.sha, text: unb64(d.content) }; }
async function putFile(path, text, message, sha) { return gh(`/contents/${path}`, { method:'PUT', body: JSON.stringify({ message, content: b64(text), branch: BRANCH, ...(sha ? {sha} : {}) }) }); }
async function listDirs() { const root = await gh(`/contents?ref=${BRANCH}`); return root.filter(x => x.type === 'dir' && /^\d+$/.test(x.name)).map(x => Number(x.name)).sort((a,b)=>a-b); }
function parseTicket(number, text) {
  const [head, ...rest] = text.replace(/\r\n/g,'\n').split('\n\n'); const meta = {}; for (const l of head.split('\n')) { const m = l.match(/^([^:]+):\s*(.*)$/); if (m) meta[m[1].toLowerCase()] = m[2]; }
  return { number, title: meta.title||'', author: meta.author||'', assignee: meta.assignee||'', created: meta.created||'', state: meta.state||'', project: meta.project||'', body: rest.join('\n\n'), url: `${SITE_URL}${number}/` };
}
function formatTicket(t) { return `Title: ${t.title || ''}\nAuthor: ${t.author || 'ali@humano.ai'}\nAssignee: ${t.assignee || 'al3rez'}\nCreated: ${t.created || dateRfc()}\nState: ${t.state || 'open'}\nProject: ${t.project || 'humanoai'}\n\n${t.body || ''}\n`; }
async function allTickets() { const nums = await listDirs(); const out=[]; for (const n of nums) { try { out.push(parseTicket(n, (await getFile(`${n}/index.md`)).text)); } catch {} } return out; }

async function callTool(name, args={}) {
  if (name === 'list_tickets') { let ts = await allTickets(); if (args.state) ts = ts.filter(t=>t.state===args.state); if (args.project) ts = ts.filter(t=>t.project===args.project); if (args.assignee) ts = ts.filter(t=>t.assignee===args.assignee); return ts; }
  if (name === 'get_ticket') { const n = Number(args.number); return parseTicket(n, (await getFile(`${n}/index.md`)).text); }
  if (name === 'create_ticket') { const nums = await listDirs(); const n = (nums.at(-1)||0)+1; const t = { title: args.title, body: args.body, project: args.project, assignee: args.assignee, author: args.author, state:'open' }; await putFile(`${n}/index.md`, formatTicket(t), `Create ticket #${n}: ${args.title}`); return { number:n, url:`${SITE_URL}${n}/`, note:'Created in GitHub. Run/generate Pages workflow if needed.' }; }
  if (name === 'update_ticket') { const n=Number(args.number); const f=await getFile(`${n}/index.md`); const t=parseTicket(n,f.text); for (const k of ['title','body','state','project','assignee']) if (args[k] !== undefined) t[k]=args[k]; await putFile(`${n}/index.md`, formatTicket(t), `Update ticket #${n}: ${t.title}`, f.sha); return { number:n, updated:true, url:`${SITE_URL}${n}/` }; }
  if (name === 'close_ticket') return callTool('update_ticket', { number: args.number, state: 'closed' });
  if (name === 'list_projects') return [...new Set((await allTickets()).map(t=>t.project).filter(Boolean))].sort();
  if (name === 'list_assignees') return [...new Set((await allTickets()).map(t=>t.assignee).filter(Boolean))].sort();
  throw new Error(`Unknown tool: ${name}`);
}

async function handleRpc(req, res, body) {
  const msg = JSON.parse(body || '{}'); const method = msg.method; const id = msg.id ?? null;
  try {
    if (method === 'initialize') return json(res, 200, { jsonrpc:'2.0', id, result:{ protocolVersion:'2024-11-05', capabilities:{ tools:{} }, serverInfo:{ name:'humano-ticket-mcp', version:'1.0.0' } } });
    if (method === 'tools/list') return json(res, 200, { jsonrpc:'2.0', id, result:{ tools } });
    if (method === 'tools/call') { const r = await callTool(msg.params?.name, msg.params?.arguments || {}); return json(res, 200, { jsonrpc:'2.0', id, result:{ content:textContent(r) } }); }
    return json(res, 200, { jsonrpc:'2.0', id, error:{ code:-32601, message:'Method not found' } });
  } catch (e) { return json(res, 200, { jsonrpc:'2.0', id, error:{ code:-32000, message:e.message } }); }
}

http.createServer((req,res)=>{
  if (req.url === '/health') return json(res, 200, { ok:true, repo:`${OWNER}/${REPO}`, branch:BRANCH });
  if (!checkAuth(req)) return json(res, 401, { error:'unauthorized' });
  if (req.method === 'GET' && (req.url === '/' || req.url === '/mcp')) return json(res, 200, { name:'humano-ticket-mcp', endpoints:['POST /mcp','GET /health'], tools:tools.map(t=>t.name) });
  if (req.method === 'POST' && req.url === '/mcp') { let b=''; req.on('data', c => { b += c; if (b.length > 1e6) req.destroy(); }); req.on('end',()=>handleRpc(req,res,b)); return; }
  json(res, 404, { error:'not found' });
}).listen(PORT, ()=>console.log(`humano-ticket-mcp listening on ${PORT}`));
