require 'test/unit'
require 'rubygems'

require 'rake'

load File.join(File.dirname(__FILE__), '..', 'Rakefile')

class TestProject < Test::Unit::TestCase
  def test_item_getter
    holder = Project::Util::ItemGetter.new({
      'parent' => {
        'child' => {
          'chain' => true,
        }
      },
      'childless' => true
    })

    assert_equal holder['parent.child.chain'], true 
    assert_equal holder['childless'], true

    assert_equal holder.parent.child.chain, true
    assert_equal holder.childless, true
  end

  def test_array_second
    assert_equal [1, 2].second, 2
    assert_equal [1].second, nil
  end

  def test_config
    config = Project::Config.load <<-YAML
      files:
        output: some_file.html
        layout: layout.haml
        style: style.sass
    YAML

    assert_equal config.files.output.is_a?(String), true
    assert_equal config.files.output, 'some_file.html'
    assert_equal config.get('files.output'), 'some_file.html'
    assert_equal config['files.output'], 'some_file.html'

    assert_equal config.files.layout.is_a?(String), true
    assert_equal config.files.layout, 'layout.haml'
    assert_equal config.get('files.layout'), 'layout.haml'
    assert_equal config['files.layout'], 'layout.haml'

    assert_equal config.files.style.is_a?(String), true
    assert_equal config.files.style, 'style.sass'
    assert_equal config.get('files.style'), 'style.sass'
    assert_equal config['files.style'], 'style.sass'
  end
end

