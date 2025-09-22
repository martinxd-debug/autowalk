-- AutoWalk Recorder with Save & Load
-- Made for Delta Android (ChatGPT Edition)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local recordedPositions = {}
local recording = false
local playing = false

local saveFile = "autowalk.json"

local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Window
local Window = Rayfield:CreateWindow({
   Name = "AutoWalk Recorder",
   LoadingTitle = "Recorder Loaded",
   LoadingSubtitle = "by ChatGPT",
   ConfigurationSaving = { Enabled = false }
})

-- Tab
local Tab = Window:CreateTab("Main", 4483362458)

-- Start Record
Tab:CreateButton({
   Name = "▶️ Start Record",
   Callback = function()
      if not recording then
         table.clear(recordedPositions)
         recording = true
         playing = false
         Rayfield:Notify("Recording Started", "Jalan manual dulu biar rute terekam.", 5)
         task.spawn(function()
            while recording do
               table.insert(recordedPositions, hrp.Position)
               task.wait(0.5) -- interval rekam
            end
         end)
      end
   end
})

-- Stop Record
Tab:CreateButton({
   Name = "⏹ Stop Record",
   Callback = function()
      if recording then
         recording = false
         Rayfield:Notify("Recording Stopped", "Steps saved: "..tostring(#recordedPositions), 5)
      end
   end
})

-- Play Walk
Tab:CreateButton({
   Name = "🎬 Play Walk",
   Callback = function()
      if #recordedPositions > 0 and not playing then
         playing = true
         Rayfield:Notify("Auto Walk", "Karakter mulai jalan sesuai jalur.", 5)
         for _,pos in ipairs(recordedPositions) do
            if not playing then break end
            hrp.CFrame = CFrame.new(pos)
            task.wait(0.5)
         end
         playing = false
         Rayfield:Notify("Finished", "Jalur selesai dijalankan.", 5)
      else
         Rayfield:Notify("Error", "Belum ada jalur terekam.", 5)
      end
   end
})

-- Stop Walk
Tab:CreateButton({
   Name = "⏸ Stop Walk",
   Callback = function()
      if playing then
         playing = false
         Rayfield:Notify("Stopped", "AutoWalk dihentikan.", 5)
      end
   end
})

-- Save Route
Tab:CreateButton({
   Name = "💾 Save Route",
   Callback = function()
      if #recordedPositions > 0 then
         local data = {}
         for _,pos in ipairs(recordedPositions) do
            table.insert(data, {x=pos.X, y=pos.Y, z=pos.Z})
         end
         writefile(saveFile, HttpService:JSONEncode(data))
         Rayfield:Notify("Saved", "Route saved to "..saveFile, 5)
      else
         Rayfield:Notify("Error", "Tidak ada jalur untuk disimpan.", 5)
      end
   end
})

-- Load Route
Tab:CreateButton({
   Name = "📂 Load Route",
   Callback = function()
      if isfile(saveFile) then
         local raw = readfile(saveFile)
         local data = HttpService:JSONDecode(raw)
         recordedPositions = {}
         for _,pos in ipairs(data) do
            table.insert(recordedPositions, Vector3.new(pos.x, pos.y, pos.z))
         end
         Rayfield:Notify("Loaded", "Route loaded. Steps: "..tostring(#recordedPositions), 5)
      else
         Rayfield:Notify("Error", "File tidak ditemukan: "..saveFile, 5)
      end
   end
})
