require_relative 'ruby_mappings/add_test_defaults'
require_relative 'ruby_mappings/add_test_dependencies'
require_relative 'ruby_mappings/check_test_args'
require_relative 'ruby_mappings/expand_source_files'
require_relative 'ruby_mappings/ruby_docs'
require_relative 'ruby_mappings/ruby_gem'
require_relative 'ruby_mappings/ruby_library'
require_relative 'ruby_mappings/ruby_linter'
require_relative 'ruby_mappings/ruby_test'

class RubyMappings
  def add_all(fun)
    fun.add_mapping "ruby_library", RubyLibrary.new

    fun.add_mapping "ruby_test", CheckTestArgs.new
    fun.add_mapping "ruby_test", AddTestDefaults.new
    fun.add_mapping "ruby_test", ExpandSourceFiles.new
    fun.add_mapping "ruby_test", RubyTest.new
    fun.add_mapping "ruby_test", AddTestDependencies.new

    fun.add_mapping "ruby_lint", ExpandSourceFiles.new
    fun.add_mapping "ruby_lint", RubyLinter.new

    fun.add_mapping "rubydocs", RubyDocs.new
    fun.add_mapping "rubygem", RubyGem.new
  end
end

def ruby(opts)
  cmd = %w(bundle exec ruby -w)
  cmd << "-d"   if opts[:debug]

  if opts.has_key? :include
    cmd << "-I"
    cmd << Array(opts[:include]).join(File::PATH_SEPARATOR)
  end

  cmd << "-S" << opts[:command] if opts.has_key?(:command)
  cmd += Array(opts[:args]) if opts.has_key?(:args)
  cmd += Array(opts[:files]) if opts.has_key?(:files)

  puts cmd.join(' ')

  sh(*cmd)
end
