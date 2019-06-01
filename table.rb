require './klient.rb'
require './zamowienie.rb'
class Table
    @@id = 0 
    attr_reader :clients
    attr_accessor :stage, :ready, :clean
    def initialize
        @id = @@id
        @@id += 1
        @clients = []
        @ready = false
        @clean = true
        @stage = ''
    end

    def new_clients
        rng = Random.new
        r = rng.rand(1..4)
        (1..r).each do |x|
            @clients << Client.new
        end
        @clean = false
        @stage = 'menu'
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

    def clean
        @clean = true
    end

    def pass_time
        unless @clients.empty?
            @clients.each do |x|
                x.pass_time
            end
            check
        end
    end

    def pass_order
        o = Order.new
        @clients.each do |x|
            o.add x.order
            x.status = 'wait for food'
        end
        @ready = false
        @stage = 'wait for food'
        o
    end

    def to_status
        string = 'Stół '+@id.to_s+ ": \n"
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

    def empty?
        return @clients.empty?
    end

    def eql?(x)
        self.class === x and x.id == @id
    end

    alias eql? ==

    def hash
        @id.hash
    end
end