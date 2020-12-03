require 'sinatra'
require 'json'

class RegaloneNatalone < Sinatra::Base
    get '/regalonenatalone' do
        randomPresentSelector()
    end
    get '/riprovaesaraipiufortunato' do
        tryAgain()
    end
end

def randomPresentSelector()
    #Lettura JSON e scrittura variabili persone disponibili o selezionate
    file = File.read('./loschiindividui.json')
    loschiindividui = JSON.parse(file)['loschiindividui']
    chosenones = JSON.parse(file)['chosenones']

    #Estrazione random di chi riceverà il regalo tra le persone disponibili
    ilfortunato = loschiindividui[rand(loschiindividui.length())]
    loschiindividui.delete(ilfortunato)
    chosenones.push(ilfortunato)

    #Riscrittura file JSON
    updateJSONFile(file, loschiindividui, chosenones)

    #Risposta persona selezionata
    content_type :json
    ilfortunato.to_json
end

def tryAgain()
    #Lettura JSON e scrittura variabili persone disponibili o selezionate
    file = File.read('./loschiindividui.json')
    loschiindividui = JSON.parse(file)['loschiindividui']
    chosenones = JSON.parse(file)['chosenones']

    #Selezione ultima persona ottenuta e cancellazione dalla lista selezionate
    notyetchosen = chosenones.last
    puts('chosenones before edit: ', chosenones)
    chosenones.delete(notyetchosen)
    puts('chosenones after edit: ', chosenones)
    loschiindividui.push(notyetchosen)

    #Update del file JSON e riavvio della selezione random
    updateJSONFile(file, loschiindividui, chosenones)
    randomPresentSelector()

end

def updateJSONFile(file, loschiindividui, chosenones)
    hash = JSON.load(file)
    hash['loschiindividui'] = loschiindividui
    hash['chosenones'] = chosenones
    File.write('./loschiindividui.json', JSON.dump(hash))
end