# mahout

## Install
```
git clone git@github.com:AndrewJDawes/mahout.git
```
## Prepare

* Create a main exports directory where you can store all exports from Evernote
    * Inside this main exports directory, create 1 subdirectory per Evernote notebook
    * Manually export all your Evernote notebooks (.enex) to the appropriate subdirectories
    * Each notebook subdirectory should have 1 or more .enex files
* This is what your exports directory should look like when finished:
    * https://www.awesomescreenshot.com/image/11111916?key=07686486463d9c9811cf8bddb7bea0d3

## Run
Change into the local repo:
```
cd mahout
```
Run the ./transfer script, pointing to your main exports directory:
```
./transfer.sh <path-to-your-exports-folder>
```
