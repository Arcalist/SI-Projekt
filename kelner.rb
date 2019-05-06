class Waiter
    @@id = 1
    def initialize
        @id = @@id
        @@id += 1
    end

    def pass_order k
        k.pass_order order
    end
end