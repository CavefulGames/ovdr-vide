--!nolint LocalShadow

local RunService = game:GetService("RunService")

-- Licensed under the MIT License, Copyright (c) 2024 jack.ink
-- Modified by jiwonz

-- Original types credit to: https://github.com/lune-org/lune/blob/414d8ff8f3f6a566dada5ad17375260ee312b293/types/task.luau
-- Original descriptions credit to: https://create.roblox.com/docs/reference/engine/libraries/task

local function resumeWithErrorCheck(thread: thread, ...: any): ()
	local success, message = coroutine.resume(thread, ...)
	if not success then
		print("Error:", message)
	end
end

local clock = 0

local waitingThreads: { [thread]: { resume: number } & ({ start: number } | { start: nil, n: number, [number]: any }) } =
	{}

local function processWaiting(): ()
	local processing = waitingThreads
	waitingThreads = {}

	for thread, data in processing do
		if coroutine.status(thread) ~= "dead" then
			if type(data) == "table" and clock >= data.resume then
				if data.start then
					resumeWithErrorCheck(thread, clock - data.start)
				else
					resumeWithErrorCheck(thread, table.unpack(data, 1, data.n))
				end
			else
				waitingThreads[thread] = data
			end
		end
	end
end

--[=[
	@class TaskLibrary

	Allows for functions and threads to be coordinated with the Task Scheduler.

	### Example usage

	```luau
	local task = require("./task")

	-- Waiting for a certain amount of time
	task.wait(1)
	print("Waited for one second")

	-- Running a task after a given amount of time
	task.delay(2, function()
		print("Ran after two seconds")
	end)

	-- Spawning a new task that runs concurrently
	task.spawn(function()
		print("Running instantly")
		task.wait(1)
		print("One second passed inside the task")
	end)

	print("Running after task.spawn yields")
	```
]=]
local task = {}

--[=[
	@within TaskLibrary

	Yields the current thread until the next Heartbeat in which the given duration (in seconds) has passed, without throttling.
]=]
function task.wait(duration: number?): number
	-- selene: allow(shadowing)
	local duration = duration or 0

	waitingThreads[coroutine.running()] = { resume = clock + duration, start = clock }
	return coroutine.yield()
end

--[=[
	@within TaskLibrary

	Schedules a function/coroutine to be called/resumed on the next Heartbeat after the given duration (in seconds) has passed, without throttling.
]=]
function task.delay<A..., R...>(duration: number, functionOrThread: thread | (A...) -> R..., ...: A...): thread
	local thread = if type(functionOrThread) == "thread" then functionOrThread else coroutine.create(functionOrThread)

	local data: { [any]: any } = table.pack(...)
	data.resume = clock + duration
	waitingThreads[thread] = data

	return thread
end

local deferredThreads: { { thread: thread, args: { [number]: any, n: number } } } = {}

local function processDeferred(): ()
	local i = 1

	while i <= #deferredThreads do
		local data = deferredThreads[i]

		if coroutine.status(data.thread) ~= "dead" then
			resumeWithErrorCheck(data.thread, table.unpack(data.args))
		end

		i += 1
	end

	table.clear(deferredThreads)
end

--[=[
	@within TaskLibrary

	Calls/resumes a function/coroutine at the end of the current resumption cycle.
]=]
function task.defer<A..., R...>(functionOrThread: thread | (A...) -> R..., ...: A...): thread
	local thread = if type(functionOrThread) == "thread" then functionOrThread else coroutine.create(functionOrThread)
	table.insert(deferredThreads, { thread = thread, args = table.pack(...) })

	return thread
end

--[=[
	@within TaskLibrary

	Calls/resumes a function/coroutine immediately through the engine scheduler.
]=]
function task.spawn<A..., R...>(functionOrThread: thread | (A...) -> R..., ...: A...): thread
	local thread = if type(functionOrThread) == "thread" then functionOrThread else coroutine.create(functionOrThread)
	resumeWithErrorCheck(thread, ...)

	return thread
end

--[=[
	@within TaskLibrary

	Cancels a thread, preventing it from being resumed.
]=]
function task.cancel(thread: thread)
	coroutine.close(thread)
end

RunService.Heartbeat:Connect(function(deltaTime)
	clock += deltaTime
	processWaiting()
	processDeferred()
end)

return task
