require 'sinatra'
require 'json'

class RegaloneNatalone < Sinatra::Base
    get '/regalonenatalone' do
        eljugador = params['eljugador']
        randomPresentSelector(eljugador)
    end
end

def randomPresentSelector(eljugador)
    file = File.read('./loschiindividui.json')
    loschiindividui = JSON.parse(file)['loschiindividui']
    primapartita = JSON.parse(file)['primapartita']
    ilfortunato = {}
    if (primapartita) 
        loschiindividui = loschiindividui.shuffle
        ilfortunato = getLuckyPerson(loschiindividui, eljugador)
        updateJSONFile(file, loschiindividui)
    else
        ilfortunato = getLuckyPerson(loschiindividui, eljugador)
    end
    content_type :json
    ilfortunato.to_json

end

def getLuckyPerson(loschiindividui, eljugador)
    ilfortunato = loschiindividui.find {|s| s['nome'].downcase == eljugador.downcase}
    indexfortunato = loschiindividui.index(ilfortunato)
    if (indexfortunato == nil)
        return { "error": "Hai inserito un utente non valido, deve essere un padres o una madres!" }
    elsif ((indexfortunato + 1) == loschiindividui.length)
        return loschiindividui[0]
    else
        return loschiindividui[indexfortunato + 1]
    end
end

def updateJSONFile(file, loschiindividui)
    hash = JSON.load(file)
    hash['loschiindividui'] = loschiindividui
    hash['primapartita'] = false
    File.write('./loschiindividui.json', JSON.dump(hash))
end