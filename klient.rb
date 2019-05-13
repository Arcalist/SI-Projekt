class Client
    attr_accessor :wait, :order
    @@id = 1
    def initialize
        @id = @@id
        @@id += 1
        @status = 'order'
        self.generate_wait_time
    end

    def pass_time
        if @wait > 0 then @wait -= 1
        end
    end
    
    def generate_wait_time
        rng = Random.new
        if @status == "eat" then @wait = rng.rand(3..10)                
        end
        if @status == "order" then @wait = rng.rand(1..6)
        end
    end

    def get_menu menu
        @menu = menu
    end

    def pick_order
        @order = @menu.dishes.sample
    end

end