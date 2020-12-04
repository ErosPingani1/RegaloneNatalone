require 'sinatra'
require 'json'

class RegaloneNatalone < Sinatra::Base
    get '/regalonenatalone' do
        eljugador = params['eljugador']
        randomPresentSelector(eljugador)
    end
end

def randomPresentSelector(eljugador)
    #Lettura JSON e scrittura variabili persone disponibili o selezionate
    file = File.read('./loschiindividui.json')
    loschiindividui = JSON.parse(file)['loschiindividui']
    chosenones = JSON.parse(file)['chosenones']
    #Estrazione random di chi riceverà il regalo tra le persone disponibili
    ilfortunato = loschiindividui[rand(loschiindividui.length())]
    if (ilfortunato['nome'].downcase == eljugador.downcase)
        tryAgain(eljugador)
    else
        loschiindividui.delete(ilfortunato)
        chosenones.push(ilfortunato)
        #Riscrittura file JSON
        updateJSONFile(file, loschiindividui, chosenones)
        #Risposta persona selezionata
        content_type :json
        ilfortunato.to_json
    end
end

def tryAgain(eljugador)
    randomPresentSelector(eljugador)
end

def updateJSONFile(file, loschiindividui, chosenones)
    hash = JSON.load(file)
    hash['loschiindividui'] = loschiindividui
    hash['chosenones'] = chosenones
    File.write('./loschiindividui.json', JSON.dump(hash))
end