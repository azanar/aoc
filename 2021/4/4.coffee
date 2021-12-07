_ = require('lodash')

context = {
    cards: []
}

class Card
    constructor: (@card) ->
        @index = indexCard(@card)
        @cols = {} 
        @rows = {} 
        @rows[k] = new Set() for k in [0..4]
        @cols[k] = new Set() for k in [0..4]
        @nums = new Set()
        @nums.add(n) for n in Object.keys(@index)
        @winning = false

    play: (draw) ->
        coord = @index[draw]
        if coord?
            @nums.delete(draw)
            @rows[coord.row].add(coord.col)
            if @rows[coord.row].size == 5
                @winning = true

            @cols[coord.col].add(coord.row)
            if @cols[coord.col].size == 5
                @winning = true

    leftSum: -> 
        Array.from(@nums.values()).map((x) -> parseInt(x)).reduce((a,b) -> a+b)

process = () ->
    state={type: 'init'}

    readline = require('readline')
    process = require('process')

    rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout
    });

    rl.on('close', () ->
        cards = (new Card(card) for card in context.cards)
        for draw in context.draws
            for card in cards
                card.play(draw)
            [won, left] = _.partition(cards, (c) -> c.winning)
            if _.isEmpty(left)
                console.log(draw)
                console.log(won[0].leftSum())
                return
            cards = left
    )

    rl.on('line', (line) ->
        switch state.type
            when 'init'
                sanitized = line.split(",")
                context.draws=sanitized
                state={type: 'skip'}
            when 'skip'
                state={type: 'card', line: 1}
            when 'card'
                sanitized = line.split(" ").filter((elt) -> elt != '')
                switch state.line
                    when 1
                        context.cards.push([sanitized])
                        state.line = state.line + 1
                    when 2,3,4
                        context.cards.at(-1).push(sanitized)
                        state.line = state.line + 1
                    when 5
                        context.cards.at(-1).push(sanitized)
                        state={type: 'skip'}
    )

indexCard = (card) ->
    card.reduce((locs, row, ridx) ->
        row.reduce((l, elt, cidx) ->
            l[elt] = {row: ridx, col: cidx}
            l
        , locs)
        locs
    {})


winning = (card, draws) ->
    step = (draw, rest) ->
        if _.isEmpty(rest)
            return false

        coord = card.index[draw]
        if coord?
            rows[coord.row].add(coord.col)
            if rows[coord.row].size == 5
                return {
                    draw: draw
                }

            cols[coord.col].add(coord.row)
            if cols[coord.col].size == 5
                return {
                    draw: draw
                }
        step(_.head(rest), _.tail(rest))

    step(_.head(draws), _.tail(draws))



process()
