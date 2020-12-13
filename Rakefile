require 'bundler/gem_tasks'
require 'rake/testtask'
require 'json'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.test_files = FileList['test/*_test.rb']
end

task test: :docs

desc 'Generate standard library documentation.'
task :docs do |t|
  docs = {}

  Dir.chdir('lib/spitewaste/libspw') do |d|
    %w[array.spw stack.spw util.spw string.spw math.spw].each do |path|
      lib = File.basename path, '.spw'
      docs[lib] = extract_docs path
    end

    File.open('docs.json', ?w) { |f| JSON.dump docs, f }
  end
end

def extract_docs path
  docs = {}
  buffer = ''

  File.open(path).each_line do |line|
    if line.strip.empty?
      buffer.clear
    elsif line[/^([^_]\S+):/]
      docs[$1] = parse_doc buffer.dup unless buffer.empty?
      buffer.clear
    elsif line[/^;/]
      buffer << line
    end
  end

  docs
end

def strpack s
  s.bytes.zip(0..).sum { |b, e| b * 128 ** e }
end

def parse_stack s
  s.scan(/"[^"]*"|\S+/).map { Integer(_1) rescue strpack _1.delete %('") }
end

StackRx = /(?<=\[)[^\]]*(?=\])/ # match [.*], but don't capture the brackets

def parse_doc doc
  # strip comment character and any implementation details
  doc.gsub!(/; */, '').gsub!(/^!.+\n/, '')

  head, specs = doc.split "\n\n"
  *desc, effect = head.split ?\n
  desc *= ?\n

  cases = []
  specs.scan(StackRx).each_slice 2 do |spec|
    cases << spec.map { parse_stack _1 }
  end if specs

  {full: doc, desc: desc, effect: effect, cases: cases}
end

task default: :test
