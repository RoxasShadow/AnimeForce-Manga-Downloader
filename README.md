`ruby animeforce.rb -h` Show the help

`ruby animeforce.rb -l` Show a list with all the manga

`ruby animeforce.rb -c "Beelzebub"` Show the available chapters for Beelzebub

`ruby animeforce.rb -g "Beelzebub","C:\\Manga\\Beelzebub\\"` Download all the chapter of Soul Eater in C:\Manga\Beelzebub\

`ruby animeforce.rb -g "Beelzebub","C:\\Manga\\Beelzebub\\",1,12` Download the first 12 chapters of Beelzebub in C:\Manga\Beelzebub\

`ruby animeforce.rb -g "Green Blood","C:\\Manga\\Green Blood\\",8,11,2` Download the chapters 8-11 of volume 2 of Green Blood in C:\Manga\Green Blood\

For -c and -l you need Nokogiri gem, so

`(rvm|sudo)gem install nokogiri`
