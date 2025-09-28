Title: CSS max-width not working properly
Author: rodarima
Created: Sun, 24 Dec 2023 18:15:51 +0000
State: closed

Example page:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Test max-width CSS property</title>
    <style>
      body {max-width: 200px}
    </style>
  </head>
  <body>
    <p>
    This is a rather long text to increase the maximal paragraph
    width. Sed ut perspiciatis, unde omnis iste natus error sit voluptatem
    accusantium doloremque laudantium, totam rem aperiam eaque ipsa, quae
    ab illo inventore veritatis et quasi architecto beatae vitae dicta
    sunt, explicabo. nemo enim ipsam voluptatem, quia voluptas sit,
    aspernatur aut odit aut fugit, sed quia consequuntur magni dolores
    eos, qui ratione voluptatem sequi nesciunt, neque porro quisquam est,
    qui dolorem ipsum, quia dolor sit, amet, consectetur, adipisci velit,
    sed quia non numquam eius modi tempora incidunt, ut labore et dolore
    magnam aliquam quaerat voluptatem. ut enim ad minima veniam, quis
    nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut
    aliquid ex ea commodi consequatur? quis autem vel eum iure
    reprehenderit, qui in ea voluptate velit esse, quam nihil molestiae
    consequatur, vel illum, qui dolorem eum fugiat, quo voluptas nulla
    pariatur?
    </p>
  </body>
</html>
```

Renders like this:

![bad-max-width](https://github.com/dillo-browser/dillo/assets/3866127/8158e412-6a34-4c7a-b9c7-b12671819039)

While the width should be constrained to 200 px, like this in Firefox:

![image](https://github.com/dillo-browser/dillo/assets/3866127/3404bab3-52ba-4a75-a09f-df92eef9bc02)
