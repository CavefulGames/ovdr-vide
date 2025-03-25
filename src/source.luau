local graph = require "./graph"
type Node<T> = graph.Node<T>
local create_source_node = graph.create_source_node
local push_child_to_scope = graph.push_child_to_scope
local update_descendants = graph.update_descendants
local equalCheckers = require "./ovdr/equalCheckers"

export type Source<T> = (() -> T) & ((value: T) -> T)

local function source<T>(initial_value: T): Source<T>
    local node = create_source_node(initial_value)

    local function update_source(...): T
        if select("#", ...) == 0 then -- no args were given
            push_child_to_scope(node)
            return node.cache
        end

        local v = ... :: T
        local t = typeof(v)
        if (type(v) ~= "table" or table.isfrozen(v)) then
            local equalChecker = equalCheckers[t]
            if equalChecker and equalChecker(node.cache, v) then
                return v
            end
            if node.cache == v then
                return v
            end
        end

        node.cache = v
        update_descendants(node)
        return v
    end

    return update_source
end

return source :: (<T>(initial_value: T) -> Source<T>) & (<T>() -> Source<T>)
