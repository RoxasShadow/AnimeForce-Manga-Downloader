`ruby animeforce.rb -h` Show the help

`ruby animeforce.rb -l` Show a list with all the manga

`ruby animeforce.rb -c "Soul Eater"` Show the available chapters for Soul Eater

`ruby animeforce.rb -g "Soul Eater","C:\\Manga\\Soul Eater\\"` Download all the chapter of Soul Eater in C:\Manga\Soul Eater\

`ruby animeforce.rb -g "Soul Eater","C:\\Manga\\Soul Eater\\",100,101,102` Download the chapters 100, 101 and 102 of Soul Eater in C:\Manga\Soul Eater\

For -c and -l you need Nokogiri gem, so

`(rvm|sudo)gem install nokogiri`
