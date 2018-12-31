# omikuji
# nihongo utenai dousiyou
def run_omikuji(user)
  user_id = user
  # file
  file_path = "/home/jf712/projects/ako2/data/users/#{user_id}"
  if File.exists?(file_path)
    # aru
    n = open(file_path).read.to_i
    open(file_path, "w") do |file|
      file.puts(n+1)
    end
  else
    # nai
    system("touch #{file_path}")
    open(file_path, "w") do |file|
      file.puts(1)
    end
  end

  # omikuji 
  message = "Today's <@#{user_id}> unsei is... "
  p number = Time.now.strftime("%Y%d%m").to_i + user_id.to_i(36)
  case number % 32
  when 0..6
    message += "大吉"
  when 7..12
    message += "吉"
  when 13..15
    message += "中吉"
  when 16..18
    message += "小吉"
  when 19..21
    message += "半吉"
  when 22..24
    message += "末吉"
  when 25..26
    message += "末小吉"
  when 27
    message += "凶"
  when 28
    message += "小凶"
  when 29
    message += "半凶"
  when 30
    message += "末凶"
  when 31
    message += "大凶"
  end
  message += " !!"
  return message
end
