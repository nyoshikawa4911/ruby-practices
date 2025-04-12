# frozen_string_literal: true

require 'fakefs/safe'
require_relative '../../optional_argument'
require_relative '../../container/directory'
require_relative '../../formatter/formatter_factory'
require_relative '../../formatter/short_formatter'

RSpec.describe ShortFormatter do
  describe '#generate_content' do
    before do
      OptionalArgument.instance.instance_variable_set(:@initialized, nil)
    end

    let(:file_names) { %w[0テスト用ファイル hoge.txt fuga.txt Piyo.txt 9.tmp 1.tmp 10.tmp .foo _bar 練習問題 テスト てすと test用ファイル] }

    context '表示対象のパスについて' do
      it '空のディレクトリのパスの場合は空文字を表示すること' do
        OptionalArgument.instance.setup({ 'a' => false, 'l' => false, 'r' => false })
        ENV['COLUMNS'] = '78'

        FakeFS.activate!
        FakeFS::FileSystem.clear
        FileUtils.mkdir('empty_directory')
        container = Directory.new('empty_directory')
        FakeFS.deactivate!

        formatter = FormatterFactory.create(container)

        expect(formatter.generate_content).to eql ''
      end
    end

    context 'ターミナル幅と表示する列数について' do
      context 'ターミナル幅が「(エントリ名の最大バイト数 + 1) * 3」である場合' do
        it '３列でショートフォーマットで表示すること' do
          OptionalArgument.instance.setup({ 'a' => false, 'l' => false, 'r' => false })
          ENV['COLUMNS'] = '78'

          FakeFS.activate!
          FakeFS::FileSystem.clear
          file_names.each { |file_name| FileUtils.touch(file_name) }
          container = Directory.new('./')
          FakeFS.deactivate!

          formatter = FormatterFactory.create(container)

          expected_3_columns = <<~TEXT
            0テスト用ファイル         Piyo.txt                  test用ファイル
            1.tmp                     _bar                      てすと
            10.tmp                    fuga.txt                  テスト
            9.tmp                     hoge.txt                  練習問題
          TEXT
          expect(formatter.generate_content).to eql expected_3_columns
        end
      end

      context 'ターミナル幅が「(エントリ名の最大バイト数 + 1) * 3 - 1」である場合' do
        it '２列でショートフォーマットで表示すること' do
          OptionalArgument.instance.setup({ 'a' => false, 'l' => false, 'r' => false })
          ENV['COLUMNS'] = '77'

          FakeFS.activate!
          FakeFS::FileSystem.clear
          file_names.each { |file_name| FileUtils.touch(file_name) }
          container = Directory.new('./')
          FakeFS.deactivate!

          formatter = FormatterFactory.create(container)

          expected_2_columns = <<~TEXT
            0テスト用ファイル         fuga.txt
            1.tmp                     hoge.txt
            10.tmp                    test用ファイル
            9.tmp                     てすと
            Piyo.txt                  テスト
            _bar                      練習問題
          TEXT
          expect(formatter.generate_content).to eql expected_2_columns
        end
      end
    end

    context '-a と -r オプションについて' do
      context '-a オプションが指定されている場合' do
        it '隠しファイルも含めてショートフォーマットで表示すること' do
          OptionalArgument.instance.setup({ 'a' => true, 'l' => false, 'r' => false })
          ENV['COLUMNS'] = '90'

          FakeFS.activate!
          FakeFS::FileSystem.clear
          file_names.each { |file_name| FileUtils.touch(file_name) }
          container = Directory.new('./')
          FakeFS.deactivate!

          formatter = FormatterFactory.create(container)

          expected_with_hidden_file = <<~TEXT
            .                         10.tmp                    hoge.txt
            ..                        9.tmp                     test用ファイル
            .foo                      Piyo.txt                  てすと
            0テスト用ファイル         _bar                      テスト
            1.tmp                     fuga.txt                  練習問題
          TEXT
          expect(formatter.generate_content).to eql expected_with_hidden_file
        end
      end

      context '-r オプションが指定されている場合' do
        it '降順でソートしてショートフォーマットで表示すること' do
          OptionalArgument.instance.setup({ 'a' => false, 'l' => false, 'r' => true })
          ENV['COLUMNS'] = '90'

          FakeFS.activate!
          FakeFS::FileSystem.clear
          file_names.each { |file_name| FileUtils.touch(file_name) }
          container = Directory.new('./')
          FakeFS.deactivate!

          formatter = FormatterFactory.create(container)

          expected_reverse_order = <<~TEXT
            練習問題                  hoge.txt                  9.tmp
            テスト                    fuga.txt                  10.tmp
            てすと                    _bar                      1.tmp
            test用ファイル            Piyo.txt                  0テスト用ファイル
          TEXT
          expect(formatter.generate_content).to eql expected_reverse_order
        end
      end
    end
  end
end
