local passInterval = 60 * 3

while true do
    print("Starting pass...")
    shell.run("Farm")
    print("Pass complete. Sleeping...")
    sleep(passInterval)
end
