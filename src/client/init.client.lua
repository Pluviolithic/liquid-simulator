local Players = game:GetService "Players"
local RunService = game:GetService "RunService"
local UserInputService = game:GetService "UserInputService"
local ReplicatedStorage = game:GetService "ReplicatedStorage"

local GradientCanvas = require(ReplicatedStorage.Common.lib.GradientCanvas)

local gridSizeX = 176
local gridSizeY = 144

local airColor = Color3.fromRGB(255, 253, 208)
local groundColor = Color3.fromRGB(150, 75, 0)

local maxXPosition = gridSizeX * 4
local maxYPosition = gridSizeY * 4
local minXPosition = 4
local minYPosition = 36

local customEnums = {
	Air = 0,
	Water = 1,
	Ground = 2,
}
local grid = {}

local screenGui = Instance.new("ScreenGui", Players.LocalPlayer.PlayerGui)
local canvas = GradientCanvas.new(gridSizeX, gridSizeY)

local function pointIsInFrame(relativePointPosition)
	return relativePointPosition.X >= minXPosition
		and relativePointPosition.X <= maxXPosition
		and relativePointPosition.Y >= minYPosition
		and relativePointPosition.Y <= maxYPosition
end

canvas:SetParent(screenGui)

for x = 1, gridSizeX do
	grid[x] = {}
	for y = 1, gridSizeY do
		grid[x][y] = customEnums.Air
		canvas:SetPixel(x, y, airColor)
	end
end

RunService.Heartbeat:Connect(function()
	local relativeMousePosition = UserInputService:GetMouseLocation() - screenGui.GradientCanvas.AbsolutePosition - Vector2.new(minXPosition, minYPosition)
	if not pointIsInFrame(relativeMousePosition) then
		return
	end
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local x = math.floor(relativeMousePosition.X / 4)
        local y = math.floor(relativeMousePosition.Y / 4)
        grid[x][y] = customEnums.Ground
        canvas:SetPixel(x, y, groundColor)
        canvas:Render()
    end
end)

canvas:Render()
