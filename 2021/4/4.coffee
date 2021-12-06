
context = {
    cards: []
}
process = () ->
    state={type: 'init'}

    readline = require('readline')
    process = require('process')

    rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout
    });

    rl.on('close', () ->
        console.log(context)
        console.log(context.cards[1])
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
                        context.cards.at(-1).push([sanitized])
                        state.line = state.line + 1
                    when 5
                        context.cards.at(-1).push([sanitized])
                        state={type: 'skip'}
    )


process()
