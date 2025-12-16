Title: Make a_Timeout_remove() actually remove the timeout
Author: Rodrigo Arias Mallo
Created: Tue, 16 Dec 2025 11:33:35 +0100
State: open

What is this:

    /**
     * Stop running a timeout function
     */
    void a_Timeout_remove()
    {
       /* in FLTK, timeouts run one time by default */
    }

I assume that at some point in the port from GTK timeouts used to repeat unless
stopped, and that is no longer needed with FLTK. However, we have cases in which
we want to actually remove the timeout from ever firing.

I would need to double check if uses of this empty remove can be replaced with
the actual remove.
