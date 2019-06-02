class Client
    attr_accessor :wait, :order, :status
    @@id = 1
    def initialize
        @id = @@id
        @@id += 1
        @status = 'menu'
        @wait = 0
        self.generate_wait_time
    end

    def pass_time
        if @wait > 0 then @wait -= 1 end
        if @wait <= 0 and @status == "eat"
            @status = "recover"
            generate_wait_time
        end
        if @wait <= 0 and @status == "recover"
            @status = "receipt"
        end
    end
    
    def generate_wait_time
        rng = Random.new
        if @status == "eat" then @wait = rng.rand(10..30) end            
        if @status == "order" then @wait = rng.rand(3..12) end
        if @status == "recover" then @wait = rng.rand(5..15) end
    end

    def get_menu menu
        @menu = menu
        pick_order
        @status = "order"
        generate_wait_time
    end

    def pick_order
        @order = @menu.dishes.sample
    end

    def get_food food
        @order = food
        @status = "eat"
        generate_wait_time
    end

    def to_s
        string = "Klient " + @id.to_s + ": "
        if @status == "menu" then return string + "oczekuje na menu" 
        end
        if @status == "order"
            if @wait > 0 then return string + "wybiera danie" 
            end
            return string + " gotowy do złożenia zamówienia"
        end
        if @status == "wait for food" then return string + "czeka na " + @order.to_s 
        end
        if @status == "eat"
            if @wait > 0 then return string + "je" 
            end
            return string + "skończył jeść"
        end
        if @status == "recover" then return string + "odpoczywa po zjedzonym posiłku" 
        end
        if @status == "receipt" then return string + "czeka na rachunek" 
        end
        if @status == "paying"
             if @wait > 0 then return string + " przygotowuje się do płacenia" 
             end
             return string + "gotowy do płacenia" 
        end
        if @status == "wait  change" then return string + "czeka na resztę" 
        end
        @status = "coś nie hasa"
    end
end