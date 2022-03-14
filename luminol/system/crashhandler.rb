module Crash_Handler
  require "net/http"
  require "json"
  require "digest"

  PLIGHT_FACES = [
    "",
    "_2",
    "_2b",
    "_scared",
    "_shock",
    "_why",
    "_worry",
    "_worry2",
    "_wtf",
    "3",
  ]

  @MissingFiles = ""

  # Prompt the player about automatic crash reporting, and sets up the handler accordingly.
  def self.prompt()
    unless File.exists?("lib/nopopup")
      str = "The mod automatically sends crash reports. (for now)
  They do not contain any personal information.
  However, you may not necessarily want them sent.
  Do you want to disable sending crash reports?"

      Oneshot.set_yes_no(tr("Yes"), tr("No"))
      self.reporting_enabled = !Oneshot.msgbox(Oneshot::Msg::YESNO, tr(str))
      File.new("lib/nopopup", "w")

      Oneshot.msgbox(Oneshot::Msg::INFO, tr("You can always toggle this feature in the settings menu if you change your mind."))
    end
  end

  # Is reporting enabled
  def self.reporting_enabled()
    return !File.exists?("lib/noreports")
  end

  # Enable/Disable reporting
  def self.reporting_enabled=(value)
    return if value == self.reporting_enabled

    if value
      File.delete("lib/noreports")
    else
      File.new("lib/noreports", "w")
    end

    # Ensures the file is created/deleted before continuing
    sleep(2)
  end

  # Send exceptions you want logged and reported here.
  def self.handle(error)
    if error.class == RGSSError && error.to_s == "font does not exist"
      print "Game couldn't find a font.\nPlease make sure you've installed the mod correctly."
      return
    end

    error_message = process_error(error)
    STDERR.puts error_message
    file_name = generate_error_file(error_message)
    print flavor_error_message(error_message)

    upload_crash(error_message, file_name)
  end

  # Add a missing file to be reported later.
  def self.logMissingFile(file)
    @MissingFiles += "#{file}\n"
  end

  # Report missing files unless automatic crash reporting is disabled.
  def self.outputMissingFiles()
    return if @MissingFiles == ""
    timestamp = generate_timestamp()

    crashlisturl = URI("https://raw.githubusercontent.com/Speak2Erase/OSFM-Crash-Messages/main/crashes.txt")
    crashlist = Net::HTTP.get(crashlisturl)
    crashmsg = crashlist.split("\n")

    data = {
      "avatar_url" => "https://raw.githubusercontent.com/Speak2Erase/OSFM-Crash-Messages/main/pfps/#{rand(0..37)}.png",
      "username" => "#{crashmsg.sample}",
      "content" => "**These files are missing!**",
      "embeds" => [
        {
          "title" => "**Missing files:**",
          "description" => "```\n#{@MissingFiles}```",
          "color" => rand(0..16777215),
          "timestamp" => timestamp,
          "footer" => {
            "text" => generate_version_string(),
          },
        },
      ],
    }

    if @MissingFiles.downcase.match?(/niko/)
      data["username"] = "=(◉ㅅ◉)="
    end

    send_data(data)
    @MissingFiles = ""
  end

  private

  # Sends the data to its destination unless automatic crash reporting is disabled.
  def self.send_data(data)
    return unless reporting_enabled()

    uri = URI.parse("https://discord.com/api/webhooks/842787202957836329/-tHKhNJPkTgnO1Nz14_BPJWRimeAmgkOIc2ZLaSrlpcUQl_WkZsN2F05mAHs9-UAHvWV")
    http = Net::HTTP.new(uri.hostname, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new uri.request_uri
    request.content_type = "application/json"

    request.body = data.to_json
    STDERR.puts data.to_json

    begin
      response = http.request(request)
    rescue
      ""
    end
  end

  # Adds important information for the player. Used before showing the error to the player.
  def self.flavor_error_message(error_message)
    return "An error has occurred!\nPlease report this on the Discord server, or the Steam discussions page.\nLink to the Discord server can be found on the mods page.\n\n#{error_message}"
  end

  # Convert the exception into a processed string.
  def self.process_error(error)
    message = "\t#{error.class}:\n#{error.to_s}\n"

    error.backtrace.each do |line|
      message += "─ #{line}\n"
    end

    # Anonymize data
    message = message.gsub(Dir.pwd, ".")

    return message
  end

  # Generate an error file with the message on the players machine.
  def self.generate_error_file(error_message)
    Dir.mkdir "Crashes" unless Dir.exists? "Crashes"

    file_name = Time.now.strftime("%Y_%m_%d_%H-%M-%S%z") + ".crash"
    file = File.open("Crashes/" + file_name, "wb")

    file.puts(error_message + "\n\n")

    file.flush()
    file.close()

    return file_name
  end

  # Upload the crash to the file server unless automatic crash reporting is disabled.
  def self.upload_crash(error_message, file_name)
    return unless reporting_enabled()

    timestamp = generate_timestamp()

    crash_list_url = URI("https://raw.githubusercontent.com/Speak2Erase/OSFM-Crash-Messages/main/crashes.txt")
    crash_list = Net::HTTP.get(crash_list_url)
    crash_msg = crash_list.split("\n")

    identity_hash = Digest::SHA2.hexdigest(Time.now.zone)

    data = {
      "avatar_url" => "https://raw.githubusercontent.com/Speak2Erase/OSFM-Crash-Messages/main/pfps/#{rand(0..37)}.png",
      "username" => "#{crash_msg.sample}",
      "content" => "Ah fuck, a game just crashed at **`#{timestamp}`** in **`#{$game_map ? $game_map.map_name : "startup"}`**.\nSource hash: **`#{identity_hash}`**",
      "embeds" => [
        {
          "fields" => [
            {
              "name" => "**Crash log:**",
              "value" => "https://filebin.net/fmcrashes3/#{file_name}",
              "inline" => true,
            },
            {
              "name" => "**About logs:**",
              "value" => "Logs are only kept for 6 days. They do not contain any personal information.",
              "inline" => true,
            },
          ],
          "title" => "Stack trace, for Pancakes' woes:",
          "description" => "```\n#{error_message}```",
          "color" => rand(0..16777215),
          "timestamp" => timestamp,
          "footer" => {
            "text" => generate_version_string(),
          },
        },
      ],
    }

    if error_message.downcase.match?(/niko/)
      data["username"] = "=(◉ㅅ◉)="
    elsif error_message.match?(/nil:NilClass/)
      data["username"] = "WHY ARE YOU CRASHING YOU'RE NOT NIL"
    end

    send_data(data)

    uri = URI("https://filebin.net/fmcrashes3/#{file_name}")
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "If you need some headers"
    form_data = [["text/plain", File.open("Crashes/#{file_name}", "rb")]] # or File.open() in case of local file

    request.set_form form_data, "multipart/form-data"

    begin
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http| # pay attention to use_ssl if you need it
        http.request(request)
      end
    rescue
      ""
    end
  end

  # Generates a version string.
  def self.generate_version_string()
    s = "#{$version}"
    s += " - Debug" if $debug
    return s
  end

  # Generates a timestamp string.
  def self.generate_timestamp()
    return Time.now.strftime("%Y-%m-%dT%H:%M:%S%z")
  end
end
