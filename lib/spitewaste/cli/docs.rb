def bold  s; "\e[1m#{s}\e[0m" end
def under s; "\e[4m#{s}\e[0m" end
def hi    s; "\e[7m#{s}\e[0m" end

DOCS = File.expand_path '../libspw/docs.json', __dir__

class SpitewasteCLI
  desc 'docs [OPTIONS] [TERMS...]',
    'Search for matching terms in the documentation of the standard library.'

  option :show_specs,
    desc: 'display the in-situ specs showing correct outputs for given inputs',
    type: :boolean,
    default: false,
    aliases: '-s'

  option :match_all,
    desc: 'require that all provided search terms match instead of 1+',
    type: :boolean,
    default: false,
    aliases: '-m'

  def docs *terms
    abort "need at least one search term" if terms.empty?

    docs = JSON.load File.read DOCS
    found = []
    min = options[:match_all] ? terms.size : 1

    docs.each do |lib, fns|
      fns.each do |fn, data|
        full = data['full']
        ms = terms.count { |t| full[/#{t}/i] }
        found << [lib, fn, full, ms] if ms >= min
      end
    end

    abort "no matches for terms: #{terms}" if found.empty?

    found.sort_by! { |v| -v[-1] }

    IO.popen('less -R', 'w') do |io|
      found.each do |lib, fn, full|
        full.gsub! /#{terms * ?|}/, &method(:hi)
        desc, specs = full.split "\n\n"
        io.puts "#{?- * 10}\n#{lib}/#{bold under fn} #{desc}\n\n"
        io.puts specs if options[:show_specs]
      end
    end
  end
end
