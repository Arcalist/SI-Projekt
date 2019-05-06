require './klient.rb'

class Table
    @@id = 1    
    def initialize
        @id = @@id
        @@id += 1
        @clients = []
        @ready = false
    end

    def new_clients
        rng = Random.new
        r = rng.rand(1..4)
        (1..r).each do |x|
            @clients << Client.new(self)
        end
    end

    def check
        rdy = 0
        @clients.each do |x|
            if x.order != nil && x.wait == 0
                rdy += 1
            end
        end
        if rdy == @clients.count then @ready = true end
    end

    def to_s
        'T'+@id.to_s
    end
end