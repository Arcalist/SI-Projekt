class Waiter
    @@id = 1
    def initialize location
        @id = @@id
        @@id += 1
        @location = location
    end

    def pass_order k
        k.pass_order order
    end
end