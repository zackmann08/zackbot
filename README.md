

# Get first <num> pages in <category>
response = client.query(list: 'categorymembers', cmtitle: '<category>', cmlimit: <num>)
# Get the names of the pages
response.data["categorymembers"].map{ |p| p["title"]}


response = client.query(list: 'categorymembers', cmtitle: 'Category:Pages using deprecated coordinates format', cmlimit: 1000)


# Ideas
- Clean up pages that claim to be missing coordinates but have coords... https://petscan.wmflabs.org/?psid=5503228
  * can do this with AWB
- Clean up pages that claim to be missing images but have an image