//
//  GameModelSpec.swift
//  TopGamesTests
//
//  Created by John Lima on 23/02/18.
//  Copyright © 2018 limadeveloper. All rights reserved.
//

import Quick
import Nimble
@testable import TopGames

private let topGamesJsonFileName = "top_games"

class GameModelSpec: QuickSpec {
  override func spec() {
    describe("game model spec") {
      
      let network = Network()
      var model: GameModel?
      
      beforeSuite {
        model = ((network.fetchJSON(from: topGamesJsonFileName) as? [Any])?.toModels() ?? []).first
        expect(GameModel.delete()).to(equal(true))
      }
      
      it("should have a initialized model") {
        expect(model).toNot(beNil())
        expect(model).to(beAnInstanceOf(GameModel.self))
      }
      
      it("should be able to parse data") {
        expect(model?.game?.name).to(equal("Dota 2"))
        expect(model?.game?.popularity).to(equal(140815))
        expect(model?.game?.id).to(equal(29595))
        expect(model?.game?.giantbombId).to(equal(32887))
        expect(model?.game?.image?.large).to(equal("https://static-cdn.jtvnw.net/ttv-boxart/Dota%202-272x380.jpg"))
        expect(model?.game?.image?.medium).to(equal("https://static-cdn.jtvnw.net/ttv-boxart/Dota%202-136x190.jpg"))
        expect(model?.game?.image?.small).to(equal("https://static-cdn.jtvnw.net/ttv-boxart/Dota%202-52x72.jpg"))
        expect(model?.game?.image?.template).to(equal("https://static-cdn.jtvnw.net/ttv-boxart/Dota%202-{width}x{height}.jpg"))
        expect(model?.game?.logo?.large).to(equal("https://static-cdn.jtvnw.net/ttv-logoart/Dota%202-240x144.jpg"))
        expect(model?.game?.logo?.medium).to(equal("https://static-cdn.jtvnw.net/ttv-logoart/Dota%202-120x72.jpg"))
        expect(model?.game?.logo?.small).to(equal("https://static-cdn.jtvnw.net/ttv-logoart/Dota%202-60x36.jpg"))
        expect(model?.game?.logo?.template).to(equal("https://static-cdn.jtvnw.net/ttv-logoart/Dota%202-{width}x{height}.jpg"))
        expect(model?.game?.localizedName).to(equal("Dota 2"))
        expect(model?.game?.locale).to(equal(""))
        expect(model?.viewers).to(equal(149945))
        expect(model?.channels).to(equal(756))
        expect(model?.isRecorded).to(beNil())
        expect(model?.isFavorite).to(beNil())
      }
      
      it("should be able to record data") {
        
        model?.isFavorite = true
        
        model?.recordGame { error in
          expect(error).to(beNil())
        }
        
        let gameId = model?.game?.id
        expect(gameId).toNot(beNil())
        
        let recorded = GameModel.fetchGameModel(by: gameId!)
        
        expect(recorded?.game?.name).to(equal("Dota 2"))
        expect(recorded?.game?.popularity).to(equal(140815))
        expect(recorded?.game?.id).to(equal(29595))
        expect(recorded?.game?.giantbombId).to(equal(32887))
        expect(recorded?.game?.localizedName).to(equal("Dota 2"))
        expect(recorded?.game?.locale).to(equal(""))
        expect(recorded?.viewers).to(equal(149945))
        expect(recorded?.channels).to(equal(756))
        expect(recorded?.isRecorded).to(equal(true))
        expect(recorded?.isFavorite).to(equal(true))
      }
      
      it("should be able to update favorite value") {
        let gameId = model?.game?.id
        expect(gameId).toNot(beNil())
        GameModel.updateFavorite(with: false, gameId: gameId!) { _ in
          let recorded = GameModel.fetchGameModel(by: gameId!)
          expect(recorded?.isFavorite).to(equal(false))
        }
      }
      
      afterSuite {
        expect(GameModel.delete()).to(equal(true))
      }
    }
  }
}
