-- Simple timer test to debug timer events

print("Timer Test - Press any key to start a timer, Q to quit")

while true do
    local event, p1, p2, p3 = os.pullEvent()
    print("Event: " .. event .. " p1: " .. tostring(p1))
    
    if event == "key" then
        if p1 == keys.q then
            print("Quitting...")
            break
        else
            local timerId = os.startTimer(1)
            print("Started timer with ID: " .. timerId)
        end
    elseif event == "timer" then
        print("Timer fired! ID: " .. p1)
    end
end

print("Test complete")