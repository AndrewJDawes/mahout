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

## Run
Change into the local repo:
```
cd mahout
```
Run the ./transfer script, pointing to your main exports directory:
```
./transfer.sh <path-to-your-exports-folder>
```
