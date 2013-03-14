`ruby animeforce.rb -h` Show the help

`ruby animeforce.rb -l` Show a list with all the manga

`ruby animeforce.rb -c "Nozoki Ana"` Show the available chapters for Nozoki Ana

`ruby animeforce.rb -g "Nozoki Ana","C:\\Manga\\Nozoki Ana\\"` Download all the chapter of Soul Eater in C:\Manga\Nozoki Ana\

`ruby animeforce.rb -g "Nozoki Ana","C:\\Manga\\Nozoki Ana\\",1,12` Download the first 12 chapters of Nozoki Ana in C:\Manga\Nozoki Ana\

For -c and -l you need Nokogiri gem, so

`(rvm|sudo)gem install nokogiri`
