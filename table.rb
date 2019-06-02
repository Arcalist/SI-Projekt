require './klient.rb'
class Table
    @@id = 0 
    attr_reader :clients
    attr_accessor :stage, :ready, :clean, :price
    def initialize
        @id = @@id
        @@id += 1
        @clients = []
        @ready = false
        @clean = true
        @stage = ''
        @wait = -1
        @price = 0
    end

    def default_state
        @clients = []
        @ready = false
        @clean = true
        @stage = ''
        @price = 0
        @wait = -1
    end

    def new_clients
        @clean = false
        rng = Random.new
        r = rng.rand(1..4)
        (1..r).each do |x|
            @clients << Client.new
        end
        @stage = 'menu'
    end

    def prepare_to_leave
        @wait = Random.new.rand(2..6)
        @stage = 'leaving'
    end

    def check
        rdy = 0
        receipt = 0
        @clients.each do |x|
            if x.order != nil && x.wait == 0
                rdy += 1
            end
            if x.status == "receipt"
                receipt += 1
            end
        end
        if rdy == @clients.count then @ready = true end
        if receipt == @clients.count
            @stage = "receipt"
            @ready = true 
        end
        if @wait == 0 and @stage == "pay" 
            @stage = "ready to pay" 
            @ready = true 
        end
        if @wait == 0 and @stage == "leaving"
            @stage = "left"
            @ready = true
            @clients = []
        end
    end

    def pass_time
        unless @clients.empty?
            @clients.each do |x|
                x.pass_time
            end
            check
        end
        if @wait > 0
            @wait -= 1
        end
    end

    def pass_order
        o = []
        @clients.each do |x|
            o << x.order
            x.status = 'wait for food'
        end
        @ready = false
        @stage = 'wait for food'
        o
    end

    def paying
        @wait = Random.new.rand(3..8)
        @clients.each do |c|
            c.status = "paying"
            c.wait = @wait
        end
        @stage = "pay"
        @ready = false
    end

    def to_status
        string = 'Stół '+@id.to_s+ ": \n "
        if @clients.empty? and !@clean then return string + "brudny" end
        if @clients.empty? then return string + "wolny" end
        @clients.each do |x|
            string += x.to_s + "\n"
        end
        string
    end

    def to_s
        "T"+@id.to_s
    end

    def to_i
        @clients.length
    end

    def to_int
        @id
    end

    def empty?
        return @clients.empty?
    end

    def eql?(x)
        self.class === x and x.id == @id
    end

    def clean?
        clean
    end

    alias eql? ==

end