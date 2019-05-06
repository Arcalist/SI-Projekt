class Client
    attr_accessor :wait, :order
    @@id = 1
    @@status = ['pick', 'order', 'eat', 'wait', 'pay']
    def initialize location
        @id = @@id
        @@id += 1
        @location = location
        @status = ''
        @wait = 0
    end

    def pass_time
        if @wait > 0 then @wait -= 1
        end
    end
        
    def move location
        @location = location
    end

    def get_menu menu
        @menu = menu
    end

    def pick_order
        @order = @menu.dishes.sample
    end

end