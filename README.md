A batch file to shorten long PATH environment variable by using short names.

You can check if short names are enabled with:

fsutil 8dot3name query

Since it's a good idea to disable 8dot3name because it will bring things to a crawl if you have folders with 1000's of files, you can manually give folders short names like this:

fsutil behavior set disable8dot3 0

fsutil file setshortname "Microsoft Visual Studio 14.0" msvc~14

fsutil behavior set disable8dot3 1

Use dir /x to get a listing.

Powershell is required to broadcast the change, so the next time you open a cmd prompt the changes will be there.
