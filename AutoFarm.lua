local passPeriod = 90

while true do
    print("Starting pass...")
    shell.run("Farm")
    print("Pass complete. Sleeping...")
    sleep(passPeriod)
end
