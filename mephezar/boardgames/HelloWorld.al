// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

pageextension 60200 CustomerListExt extends "Customer List"
{
    trigger OnOpenPage();
    begin
        Message('App published: Hello boardgame geek world!');

        if 1 = 2 then
            Error('');

        // ,
        //   "enableAppSourceCop": false,
        //   "enablePerTenantExtensionCop": false
    end;
}

