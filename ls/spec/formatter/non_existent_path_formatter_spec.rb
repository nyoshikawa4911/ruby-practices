# frozen_string_literal: true

require_relative '../../optional_argument'
require_relative '../../container/non_existent_path_container'
require_relative '../../formatter/formatter_factory'
require_relative '../../formatter/non_existent_path_formatter'

RSpec.describe NonExistentPathFormatter do
  describe '#generate_content' do
    before do
      OptionalArgument.instance.instance_variable_set(:@initialized, nil)
    end

    context 'コンテナに１つのエントリがある場合' do
      it 'lsコマンドの「存在しないパス」としてフォーマットすること' do
        container = NonExistentPathContainer.new(['hoge.tmp'])
        formatter = FormatterFactory.create(container)
        expect(formatter.generate_content).to eql "ls: hoge.tmp: No such file or directory\n"
      end
    end

    context 'コンテナに複数のエントリがある場合' do
      let(:formatter) do
        container = NonExistentPathContainer.new(%w[hoge.txt fuga.txt Piyo.txt 9.tmp 1.tmp 10.tmp .foo _bar 練習問題 テスト てすと])
        FormatterFactory.create(container)
      end

      let(:expected) do
        <<~TEXT
          ls: .foo: No such file or directory
          ls: 1.tmp: No such file or directory
          ls: 10.tmp: No such file or directory
          ls: 9.tmp: No such file or directory
          ls: Piyo.txt: No such file or directory
          ls: _bar: No such file or directory
          ls: fuga.txt: No such file or directory
          ls: hoge.txt: No such file or directory
          ls: てすと: No such file or directory
          ls: テスト: No such file or directory
          ls: 練習問題: No such file or directory
        TEXT
      end

      context '-r オプションが指定されている場合' do
        it '昇順にソートして、lsコマンドの「存在しないパス」としてフォーマットすること' do
          OptionalArgument.instance.setup({ 'a' => false, 'l' => false, 'r' => true })
          expect(formatter.generate_content).to eql expected
        end
      end

      context '-r オプションが指定されていない場合' do
        it '昇順にソートして、lsコマンドの「存在しないパス」としてフォーマットすること' do
          OptionalArgument.instance.setup({ 'a' => false, 'l' => false, 'r' => false })
          expect(formatter.generate_content).to eql expected
        end
      end
    end
  end
end
