# frozen_string_literal: true

require 'open3'
require 'fakefs/safe'
require_relative '../ls'

RSpec.describe LS do
  describe '#generate' do
    context 'ショートフォーマット表示' do
      let(:non_existent_paths) { %w[存在しないパス1 .存在しないパス2 _存在しないパス3 non_existent_file] }
      let(:file_paths) { %w[0テスト用ファイル hoge.txt fuga.txt Piyo.txt 9.tmp 1.tmp 10.tmp .foo _bar 練習問題 テスト てすと test用ファイル AAA.txt] }
      let(:file_paths_for_dir1) do
        %w[0test用ファイル hogehoge.txt fugafuga.txt PiyoPiyo.txt 99.tmp 1.tmp 10.tmp .foo _bar 練習問題2 テスト てすと test用のファイル MMM.txt]
      end
      let(:file_paths_for_dir2) do
        %w[0テスト用ファイル Hoge.txt uga.txt Piyo.txt 9.tmp 10.tmp 100.tmp .foobar _barbaz 練習もんだい てすと99 test用のfile KKK.txt]
      end
      let(:dir_paths) { %w[test_directory1 test_directory2 empty_directory] }

      before do
        OptionalArgument.instance.instance_variable_set(:@initialized, nil)
        ENV['COLUMNS'] = '80'

        FakeFS.activate!
        FakeFS::FileSystem.clear
        FileUtils.touch(file_paths)
        dir_paths.each { |dir_path| FileUtils.mkdir(dir_path) }
        file_paths_for_dir1.each { |file_path| FileUtils.touch("test_directory1/#{file_path}") }
        file_paths_for_dir2.each { |file_path| FileUtils.touch("test_directory2/#{file_path}") }
      end

      context '表示対象のパスについて' do
        before do
          OptionalArgument.instance.setup({ 'a' => false, 'l' => false, 'r' => false })
        end

        context '「存在しないパス」のみの場合' do
          it '実際のlsコマンドと表示が一致すること' do
            expected = <<~TEXT
              ls: .存在しないパス2: No such file or directory
              ls: _存在しないパス3: No such file or directory
              ls: non_existent_file: No such file or directory
              ls: 存在しないパス1: No such file or directory
            TEXT
            content = LS.new(non_existent_paths).generate
            FakeFS.deactivate!

            expect(content).to eql expected
          end
        end

        context '「ファイルパス」のみの場合' do
          it '実際のlsコマンドと表示が一致すること' do
            expected = <<~TEXT
              .foo                      AAA.txt                   test用ファイル
              0テスト用ファイル         Piyo.txt                  てすと
              1.tmp                     _bar                      テスト
              10.tmp                    fuga.txt                  練習問題
              9.tmp                     hoge.txt
            TEXT
            content = LS.new(file_paths).generate
            FakeFS.deactivate!

            expect(content).to eql expected
          end
        end

        context '「ディレクトリのパス」のみの場合' do
          it '実際のlsコマンドと表示が一致すること' do
            expected = <<~TEXT
              empty_directory:

              test_directory1:
              0test用ファイル        PiyoPiyo.txt           てすと
              1.tmp                  _bar                   テスト
              10.tmp                 fugafuga.txt           練習問題2
              99.tmp                 hogehoge.txt
              MMM.txt                test用のファイル

              test_directory2:
              0テスト用ファイル         Hoge.txt                  test用のfile
              10.tmp                    KKK.txt                   uga.txt
              100.tmp                   Piyo.txt                  てすと99
              9.tmp                     _barbaz                   練習もんだい
            TEXT
            content = LS.new(dir_paths).generate
            FakeFS.deactivate!

            expect(content).to eql expected
          end
        end

        context '「存在しないパス」,「ファイルのパス」の場合' do
          it '実際のlsコマンドと表示が一致すること' do
            expected = <<~TEXT
              ls: .存在しないパス2: No such file or directory
              ls: _存在しないパス3: No such file or directory
              ls: non_existent_file: No such file or directory
              ls: 存在しないパス1: No such file or directory
              .foo                      AAA.txt                   test用ファイル
              0テスト用ファイル         Piyo.txt                  てすと
              1.tmp                     _bar                      テスト
              10.tmp                    fuga.txt                  練習問題
              9.tmp                     hoge.txt
            TEXT
            content = LS.new([*non_existent_paths, *file_paths]).generate
            FakeFS.deactivate!

            expect(content).to eql expected
          end
        end

        context '「存在しないパス」,「ディレクトリのパス」の場合' do
          it '実際のlsコマンドと表示が一致すること' do
            expected = <<~TEXT
              ls: .存在しないパス2: No such file or directory
              ls: _存在しないパス3: No such file or directory
              ls: non_existent_file: No such file or directory
              ls: 存在しないパス1: No such file or directory
              empty_directory:

              test_directory1:
              0test用ファイル        PiyoPiyo.txt           てすと
              1.tmp                  _bar                   テスト
              10.tmp                 fugafuga.txt           練習問題2
              99.tmp                 hogehoge.txt
              MMM.txt                test用のファイル

              test_directory2:
              0テスト用ファイル         Hoge.txt                  test用のfile
              10.tmp                    KKK.txt                   uga.txt
              100.tmp                   Piyo.txt                  てすと99
              9.tmp                     _barbaz                   練習もんだい
            TEXT
            content = LS.new([*non_existent_paths, *dir_paths]).generate
            FakeFS.deactivate!

            expect(content).to eql expected
          end
        end

        context '「ファイルパス」,「ディレクトリのパス」の場合' do
          it '実際のlsコマンドと表示が一致すること' do
            expected = <<~TEXT
              .foo                      AAA.txt                   test用ファイル
              0テスト用ファイル         Piyo.txt                  てすと
              1.tmp                     _bar                      テスト
              10.tmp                    fuga.txt                  練習問題
              9.tmp                     hoge.txt

              empty_directory:

              test_directory1:
              0test用ファイル        PiyoPiyo.txt           てすと
              1.tmp                  _bar                   テスト
              10.tmp                 fugafuga.txt           練習問題2
              99.tmp                 hogehoge.txt
              MMM.txt                test用のファイル

              test_directory2:
              0テスト用ファイル         Hoge.txt                  test用のfile
              10.tmp                    KKK.txt                   uga.txt
              100.tmp                   Piyo.txt                  てすと99
              9.tmp                     _barbaz                   練習もんだい
            TEXT
            content = LS.new([*file_paths, *dir_paths]).generate
            FakeFS.deactivate!

            expect(content).to eql expected
          end
        end

        context '「存在しないパス」,「ファイルパス」,「ディレクトリのパス」の場合' do
          it '実際のlsコマンドと表示が一致すること' do
            expected = <<~TEXT
              ls: .存在しないパス2: No such file or directory
              ls: _存在しないパス3: No such file or directory
              ls: non_existent_file: No such file or directory
              ls: 存在しないパス1: No such file or directory
              .foo                      AAA.txt                   test用ファイル
              0テスト用ファイル         Piyo.txt                  てすと
              1.tmp                     _bar                      テスト
              10.tmp                    fuga.txt                  練習問題
              9.tmp                     hoge.txt

              empty_directory:

              test_directory1:
              0test用ファイル        PiyoPiyo.txt           てすと
              1.tmp                  _bar                   テスト
              10.tmp                 fugafuga.txt           練習問題2
              99.tmp                 hogehoge.txt
              MMM.txt                test用のファイル

              test_directory2:
              0テスト用ファイル         Hoge.txt                  test用のfile
              10.tmp                    KKK.txt                   uga.txt
              100.tmp                   Piyo.txt                  てすと99
              9.tmp                     _barbaz                   練習もんだい
            TEXT
            content = LS.new([*non_existent_paths, *file_paths, *dir_paths]).generate
            FakeFS.deactivate!

            expect(content).to eql expected
          end
        end
      end

      context 'オプション引数について' do
        context '-a オプションが指定されている場合' do
          it '実際のlsコマンドと表示が一致すること' do
            OptionalArgument.instance.setup({ 'a' => true, 'l' => false, 'r' => false })

            expected = <<~TEXT
              ls: .存在しないパス2: No such file or directory
              ls: _存在しないパス3: No such file or directory
              ls: non_existent_file: No such file or directory
              ls: 存在しないパス1: No such file or directory
              .foo                      AAA.txt                   test用ファイル
              0テスト用ファイル         Piyo.txt                  てすと
              1.tmp                     _bar                      テスト
              10.tmp                    fuga.txt                  練習問題
              9.tmp                     hoge.txt

              empty_directory:
              .  ..

              test_directory1:
              .                      99.tmp                 test用のファイル
              ..                     MMM.txt                てすと
              .foo                   PiyoPiyo.txt           テスト
              0test用ファイル        _bar                   練習問題2
              1.tmp                  fugafuga.txt
              10.tmp                 hogehoge.txt

              test_directory2:
              .                         100.tmp                   _barbaz
              ..                        9.tmp                     test用のfile
              .foobar                   Hoge.txt                  uga.txt
              0テスト用ファイル         KKK.txt                   てすと99
              10.tmp                    Piyo.txt                  練習もんだい
            TEXT
            content = LS.new([*non_existent_paths, *file_paths, *dir_paths]).generate
            FakeFS.deactivate!

            expect(content).to eql expected
          end
        end

        context '-r オプションが指定されている場合' do
          it '実際のlsコマンドと表示が一致すること' do
            OptionalArgument.instance.setup({ 'a' => false, 'l' => false, 'r' => true })

            expected = <<~TEXT
              ls: .存在しないパス2: No such file or directory
              ls: _存在しないパス3: No such file or directory
              ls: non_existent_file: No such file or directory
              ls: 存在しないパス1: No such file or directory
              練習問題                  fuga.txt                  10.tmp
              テスト                    _bar                      1.tmp
              てすと                    Piyo.txt                  0テスト用ファイル
              test用ファイル            AAA.txt                   .foo
              hoge.txt                  9.tmp

              test_directory2:
              練習もんだい              _barbaz                   9.tmp
              てすと99                  Piyo.txt                  100.tmp
              uga.txt                   KKK.txt                   10.tmp
              test用のfile              Hoge.txt                  0テスト用ファイル

              test_directory1:
              練習問題2              fugafuga.txt           10.tmp
              テスト                 _bar                   1.tmp
              てすと                 PiyoPiyo.txt           0test用ファイル
              test用のファイル       MMM.txt
              hogehoge.txt           99.tmp

              empty_directory:
            TEXT
            content = LS.new([*non_existent_paths, *file_paths, *dir_paths]).generate
            FakeFS.deactivate!

            expect(content).to eql expected
          end
        end

        context '-a -r オプションが指定されている場合' do
          it '実際のlsコマンドと表示が一致すること' do
            OptionalArgument.instance.setup({ 'a' => true, 'l' => false, 'r' => true })

            expected = <<~TEXT
              ls: .存在しないパス2: No such file or directory
              ls: _存在しないパス3: No such file or directory
              ls: non_existent_file: No such file or directory
              ls: 存在しないパス1: No such file or directory
              練習問題                  fuga.txt                  10.tmp
              テスト                    _bar                      1.tmp
              てすと                    Piyo.txt                  0テスト用ファイル
              test用ファイル            AAA.txt                   .foo
              hoge.txt                  9.tmp

              test_directory2:
              練習もんだい              Piyo.txt                  10.tmp
              てすと99                  KKK.txt                   0テスト用ファイル
              uga.txt                   Hoge.txt                  .foobar
              test用のfile              9.tmp                     ..
              _barbaz                   100.tmp                   .

              test_directory1:
              練習問題2              _bar                   0test用ファイル
              テスト                 PiyoPiyo.txt           .foo
              てすと                 MMM.txt                ..
              test用のファイル       99.tmp                 .
              hogehoge.txt           10.tmp
              fugafuga.txt           1.tmp

              empty_directory:
              .. .
            TEXT
            content = LS.new([*non_existent_paths, *file_paths, *dir_paths]).generate
            FakeFS.deactivate!

            expect(content).to eql expected
          end
        end
      end
    end

    context 'ロングフォーマット表示' do
      let(:current_path) { '.' }
      let(:non_existent_paths) { %w[存在しないパス1 .存在しないパス2 _存在しないパス3 non_existent_file] }
      let(:file_paths) { Dir.entries(current_path).filter { |path| File.ftype(path) != 'directory' } }
      let(:dir_paths) { Dir.entries(current_path).filter { |path| File.ftype(path) == 'directory' } }

      context '表示対象のパスについて' do
        before do
          OptionalArgument.instance.instance_variable_set(:@initialized, nil)
          OptionalArgument.instance.setup({ 'a' => false, 'l' => true, 'r' => false })
        end

        context '「存在しないパス」のみの場合' do
          it '実際のlsコマンドと表示が一致すること' do
            target_paths = non_existent_paths
            output, = Open3.capture2e("ls -l #{target_paths.join(' ')}")
            expect(LS.new(target_paths).generate).to eql output
          end
        end

        context '「ファイルパス」のみの場合' do
          it '実際のlsコマンドと表示が一致すること' do
            target_paths = file_paths
            output, = Open3.capture2e("ls -l #{target_paths.join(' ')}")
            expect(LS.new(target_paths).generate).to eql output
          end
        end

        context '「ディレクトリのパス」のみの場合' do
          it '実際のlsコマンドと表示が一致すること' do
            target_paths = dir_paths
            output, = Open3.capture2e("ls -l #{target_paths.join(' ')}")
            expect(LS.new(target_paths).generate).to eql output
          end
        end

        context '「存在しないパス」,「ファイルのパス」の場合' do
          it '実際のlsコマンドと表示が一致すること' do
            target_paths = [*non_existent_paths, *file_paths]
            output, = Open3.capture2e("ls -l #{target_paths.join(' ')}")
            expect(LS.new(target_paths).generate).to eql output
          end
        end

        context '「存在しないパス」,「ディレクトリのパス」の場合' do
          it '実際のlsコマンドと表示が一致すること' do
            target_paths = [*non_existent_paths, *dir_paths]
            output, = Open3.capture2e("ls -l #{target_paths.join(' ')}")
            expect(LS.new(target_paths).generate).to eql output
          end
        end

        context '「ファイルパス」,「ディレクトリのパス」の場合' do
          it '実際のlsコマンドと表示が一致すること' do
            target_paths = [*file_paths, *dir_paths]
            output, = Open3.capture2e("ls -l #{target_paths.join(' ')}")
            expect(LS.new(target_paths).generate).to eql output
          end
        end

        context '「存在しないパス」,「ファイルパス」,「ディレクトリのパス」の場合' do
          it '実際のlsコマンドと表示が一致すること' do
            target_paths = [*non_existent_paths, *file_paths, *dir_paths]
            output, = Open3.capture2e("ls -l #{target_paths.join(' ')}")
            expect(LS.new(target_paths).generate).to eql output
          end
        end
      end

      context 'オプション引数について' do
        before do
          OptionalArgument.instance.instance_variable_set(:@initialized, nil)
        end

        let(:all_type_paths) { [*non_existent_paths, *file_paths, *dir_paths] }

        context '-a オプションが指定されている場合' do
          it '実際のlsコマンドと表示が一致すること' do
            OptionalArgument.instance.setup({ 'a' => true, 'l' => true, 'r' => false })
            output, = Open3.capture2e("ls -al #{all_type_paths.join(' ')}")
            expect(LS.new(all_type_paths).generate).to eql output
          end
        end

        context '-r オプションが指定されている場合' do
          it '実際のlsコマンドと表示が一致すること' do
            OptionalArgument.instance.setup({ 'a' => false, 'l' => true, 'r' => true })
            output, = Open3.capture2e("ls -lr #{all_type_paths.join(' ')}")
            expect(LS.new(all_type_paths).generate).to eql output
          end
        end

        context '-a -r オプションが指定されている場合' do
          it '実際のlsコマンドと表示が一致すること' do
            OptionalArgument.instance.setup({ 'a' => true, 'l' => true, 'r' => true })
            output, = Open3.capture2e("ls -alr #{all_type_paths.join(' ')}")
            expect(LS.new(all_type_paths).generate).to eql output
          end
        end
      end
    end
  end
end
