class PokemonsController < ApplicationController
  def new
    @pokemon = Pokemon.new
  end

  def create
    @pokemon = Pokemon.new(pokemon_params)
    @pokemon.level = 1
    @pokemon.health = 100
    @pokemon.trainer = current_trainer

    if @pokemon.save
      redirect_to trainer_path(:id => current_trainer.id)
    else
      flash[:error] = @pokemon.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  def capture
    @pokemon = Pokemon.find(params[:id])

    if not @pokemon.trainer
      @pokemon.trainer = current_trainer
      @pokemon.save

      redirect_to :root
    else
      redirect_to :back, :alert => "You can't capture that Pokemon!"
    end
  end

  def damage
    @pokemon = Pokemon.find(params[:id])

    if @pokemon.trainer
      if params[:attack_pokemon]
        attacker = Pokemon.find(params[:attack_pokemon])

        # pokemon prefer not to attack themselves, but will if necessary
        # (it's actually a surprisingly efficient way to level up!)
        damage = attacker == @pokemon ? 5 : [((attacker.level / @pokemon.level) * 10), 5].max

        @pokemon.health = [@pokemon.health - damage, 0].max
        @pokemon.save

        if @pokemon.health <= 0
          exp = [((@pokemon.level ** 2) / attacker.level), 2].max # lol
          attacker.add_exp(exp)
          attacker.save

          flash.alert = "You killed #{@pokemon.name} and gained #{exp} experience!"
          redirect_to trainer_path(:id => @pokemon.trainer.id)
        end
      end
    else
      redirect_to :back, :alert => "You can't damage that Pokemon!"
    end
  end

  def heal
    @pokemon = Pokemon.find(params[:id])

    if @pokemon.trainer == current_trainer
      @pokemon.health = [@pokemon.health + 10, 100].min
      @pokemon.save
      redirect_to trainer_path(:id => @pokemon.trainer.id)
    else
      redirect_to :back, :alert => "You can only heal your own Pokemon!"
    end
  end

  private
  def pokemon_params
    params.require(:pokemon).permit(:name)
  end
end
