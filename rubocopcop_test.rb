require 'minitest/autorun'
require 'fileutils'
require 'tmpdir'
require 'yaml'

describe 'rubocopcop' do
  def setup
    @dir = Dir.mktmpdir
  end

  def inside_test_dir(&block)
    Dir.chdir(@dir, &block)
  end

  def teardown
    FileUtils.remove_entry(@dir)
  end

  def basedir
    File.dirname(__FILE__)
  end

  def run_rubocopcop
    `#{rubocopcop_file}`
  end

  def rubocopcop_file
    File.join(basedir, 'rubocopcop.rb')
  end

  def read_config(file)
    YAML.load_file(file)
  end

  def default_config
    read_config(File.join(basedir, '.rubocop.yml'))
  end

  def current_config
    read_config('.rubocop.yml')
  end

  def compiled_config
    YAML.load(`rubocop --show-cops`)
  end

  def write_test_config
    raise 'rubocop file already exists' if File.exist?('.rubocop.yml')
    File.write('.rubocop.yml', <<EOF)
AllCops:
  DisabledByDefault: true

Style/MethodDefParentheses:
  Description: Old description
  StyleGuide: http://github.com/bbatsov/ruby-style-guide#method-parens
  Enabled: true
  EnforcedStyle: require_no_parentheses
  SupportedStyles:
  - require_parentheses
  - require_no_parentheses

Style/EachWithObject:
  Enabled: false
EOF
  end

  describe 'inside directory without rubocop configuration' do
    it "initializes the rubocop environment based on its own defaults" do
      inside_test_dir do
        run_rubocopcop
        assert File.exist?('.rubocop.yml')
      end
    end
  end

  describe 'inside directory with existing rubocop configuration' do
    it "adds new cops to configuration" do
      inside_test_dir do
        write_test_config
        run_rubocopcop
        assert current_config.key?('Style/MethodMissing'), 'configuration is missing new cops'
        refute current_config['Style/MethodMissing']['Enabled'], 'new cop is enabled'
      end
    end

    it "keeps AllCops configuration" do
      inside_test_dir do
        write_test_config
        run_rubocopcop
        assert current_config.key?('AllCops'), 'AllCops keys is missing'
        assert current_config['AllCops']['DisabledByDefault'], 'AllCops configuration is not preserved'
      end
    end

    it "keeps configuration of old cops" do
      inside_test_dir do
        write_test_config
        run_rubocopcop
        assert current_config.key?('Style/MethodDefParentheses'), 'configuration is missing old cops'
        assert_equal('require_no_parentheses',
                     current_config['Style/MethodDefParentheses']['EnforcedStyle'],
                     'old configuration is not preserved')
      end
    end

    it "updates information at the cop" do
      inside_test_dir do
        write_test_config
        run_rubocopcop
        assert_equal("Checks if the method definitions have or don't have parentheses.",
                     current_config['Style/MethodDefParentheses']['Description'],
                     'Description not updated')

        assert_equal("https://github.com/bbatsov/ruby-style-guide#method-parens",
                     current_config['Style/MethodDefParentheses']['StyleGuide'],
                     'StyleGuide not updated')

        expected_styles = ["require_parentheses", "require_no_parentheses", "require_no_parentheses_except_multiline"]
        assert_equal(expected_styles,
                     current_config['Style/MethodDefParentheses']['SupportedStyles'],
                     'SupportedStyles not updated')
      end
    end
  end
end
