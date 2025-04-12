# frozen_string_literal: true

require 'fakefs/safe'
require_relative '../../optional_argument'
require_relative '../../container/existent_file_path_container'
require_relative '../../container/directory'
require_relative '../../formatter/formatter_factory'
require_relative '../../formatter/long_formatter'

RSpec.describe LongFormatter do
  describe '#generate_content' do
    before do
      OptionalArgument.instance.instance_variable_set(:@initialized, nil)
    end

    let(:current_path) { '.' }

    context '表示対象のパスについて' do
      context 'ファイルパスの場合' do
        it '先頭にトータルブロックサイズを表示しないこと' do
          OptionalArgument.instance.setup({ 'a' => false, 'l' => true, 'r' => false })
          exist_file_paths = Dir.entries(current_path).filter { |path| File.ftype(path) != 'directory' }
          container = ExistentFilePathContainer.new(exist_file_paths)
          formatter = FormatterFactory.create(container)

          expected = `ls -l #{exist_file_paths.join(' ')}`
          expect(formatter.generate_content).to_not match(/\Atotal \d+/)
          expect(formatter.generate_content).to eql expected
        end
      end

      context '空のディレクトリのパスの場合' do
        it '「total 0」のみを表示すること' do
          OptionalArgument.instance.setup({ 'a' => false, 'l' => true, 'r' => false })

          FakeFS.activate!
          FakeFS::FileSystem.clear
          FileUtils.mkdir('empty_directory')
          container = Directory.new('empty_directory')
          FakeFS.deactivate!

          formatter = FormatterFactory.create(container)

          expect(formatter.generate_content).to eql "total 0\n"
        end
      end

      context 'ファイルが存在するディレクトリパスの場合' do
        it '先頭にトータルブロックサイズを表示すること' do
          OptionalArgument.instance.setup({ 'a' => false, 'l' => true, 'r' => false })
          container = Directory.new(current_path)
          formatter = FormatterFactory.create(container)

          expected = `ls -l`
          expect(formatter.generate_content).to match(/\Atotal \d+/)
          expect(formatter.generate_content).to eql expected
        end
      end
    end

    context '-a と -r オプションについて' do
      context '-a オプションが指定されている場合' do
        it '隠しファイルも含めてロングフォーマットで表示すること' do
          OptionalArgument.instance.setup({ 'a' => true, 'l' => true, 'r' => false })
          container = Directory.new(current_path)
          formatter = FormatterFactory.create(container)

          expected = `ls -al`
          expect(formatter.generate_content).to eql expected
        end
      end

      context '-r オプションが指定されている場合' do
        it '降順でソートしてロングフォーマットで表示すること' do
          OptionalArgument.instance.setup({ 'a' => false, 'l' => true, 'r' => true })
          container = Directory.new(current_path)
          formatter = FormatterFactory.create(container)

          expected = `ls -lr`
          expect(formatter.generate_content).to eql expected
        end
      end
    end
  end
end
