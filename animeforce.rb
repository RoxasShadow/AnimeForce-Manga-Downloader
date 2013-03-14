#--
# Copyright(C) 2012 Giovanni Capuano <webmaster@giovannicapuano.net>
#
# AnimeForce Manga Downloader is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# AnimeForce Manga Downloader is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with AnimeForce Manga Downloader. If not, see <http://www.gnu.org/licenses/>.
#++
#!/usr/bin/env ruby
require 'optparse'
require 'open-uri'

module AnimeForce

  def self.list
    require 'nokogiri'
    
    url = 'http://www.animeforce.org/reader/reader/list/'
    [].tap { |release|
      Nokogiri::HTML(open(url, 'Referer' => url)).xpath('//div[@class="group"]').each { |p|
        name = p.children[1].child['title']
        url  = p.children[1].child['href']
        release << { :name => name, :url => url }
      }
    }
  end
  
  def self.get_cookie(url) # required to do #count_chapters to 'adult' flagged releases.
    require 'net/http'
    require 'uri'
    
    uri = URI(url)
    req = Net::HTTP::Post.new uri.path, { 'Referer' => url }
    req.set_form_data('adult' => 'true')
    
    res = Net::HTTP.start(uri.hostname, uri.port) { |http|
      http.request req
    }
    
    res.response['set-cookie'].split('; ')[0]
  end
    
  
  def self.count_chapters(url, cookie)
    require 'nokogiri'
    
    doc = Nokogiri::HTML(open(url, 'Referer' => url, 'Cookie' => cookie)).at_xpath('//div[@class="list"]')
    return [] unless doc
    [].tap { |chapters|
      doc.xpath('//div[@class="element"]').each { |p|
        chapters << p.child.child['href'][0..-1].split(?/).last.to_i
      }
    }.reverse
  end
  
  def self.get(url, path, from, to)
    from.upto(to) { |i|
      begin
        ref = "#{url}it/0/#{i}/"
        filename = File.join(path, "#{i}.zip")
        File.open(filename, 'wb') { |f|
          f.write open(ref, 'Referer' => ref).read
        }
        puts "Chapter #{i} downloaded."
      rescue Exception => e
        puts "Error downloading chapter #{i}: #{e}"
      end
    }
  end
    
end

options = {}
help    = ''
OptionParser.new { |o|
  help = o
  
  o.on('-h', '--help', 'Show the help') {
    puts o; exit
  }
  
  o.on('-l', '--list', 'Show the publication list') {
    AnimeForce.list.each { |r|
      puts r[:name]
    }
    exit
  }
  
  o.on('-c', '--count MANGA', 'Show the available chapters') { |manga|
    release = AnimeForce.list.select { |v| v[:name] == manga }
    abort 'Not found.' if release.empty?
    
    cookie   = AnimeForce.get_cookie(release.first[:url])
    chapters = AnimeForce.count_chapters(release.first[:url], cookie)
    puts chapters.empty? ? 'Chapters count not available. Maybe it is an adult manga.' : chapters.join(', ')
    exit
  }
  
  o.on('-g', '--get MANGA,PATH,[FROM],[TO]', Array, 'Get the requested range chapters and save them in PATH') { |ary|
    abort 'Name of the manga and path where to save it is required' if ary.count < 2
    manga = ary[0]
    path  = ary[1]
    
    release = AnimeForce.list.select { |v| v[:name] == manga }
    
    abort 'Not found.' if     release.empty?
    Dir.mkdir(path)    unless File.directory? path
    
    options[:get] = ary.length == 4 ? [ release, path, ary[2], ary[3] ] : [ release, path ]
  }
}.parse!

if options[:get]
  if options[:get].count == 2
    cookie = AnimeForce.get_cookie options[:get][0].first[:url]
    count = AnimeForce.count_chapters options[:get][0].first[:url], cookie
    options[:get] << count.first
    options[:get] << count.last
  end
  
  AnimeForce.get options[:get][0].first[:url].gsub(/series/, 'download'), options[:get][1], options[:get][2], options[:get][3] 
else
  puts help
end
