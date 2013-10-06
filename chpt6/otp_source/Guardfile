mix_bin=`which mix`

#watch(/(.+\.ex)/) { |m| `mix compile --force ; mix test` }

guard 'shell', :mix_bin => mix_bin do
  watch(%r{^test/.+\.exs$}) { |m| `mix test "#{m[0]}" 1>&2` }
  watch(%r{^lib/(.+)\.ex$})     { |m| `mix test "test/#{m[1]}_test.exs" 1>&2` }
  watch(%r{^web/(.+)\.ex$})     { |m| `mix test "test/#{m[1]}_test.exs" 1>&2` }
end
