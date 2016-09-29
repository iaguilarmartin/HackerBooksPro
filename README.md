# HackerBooksPro
A more powerful version of the original [HackerBooks project](https://github.com/iaguilarmartin/HackerBooks)

Some interesting features of this app are:

* Uses **CoreData** for books data persistance
* Uses **CoreLocation** to register user location when it adds new annotations to a book
* Uses **MapKit** to display inside a Map the location of annotations of a book
* Requests accesos to device camera or photo library so each annotation can have a photo associated
* Books can be filtered by tag, author or title. This is implemented using **UISearchController**
* Now the app remember last book readed and it is displayed as rootViewController in the following session
* Annotations can be shared on social networks using **UIActivityViewController**