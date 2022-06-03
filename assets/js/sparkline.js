import * as d3 from "../vendor/d3.min"

export function sparkline(id, updatedValue) {

    const WIDTH        = 200;
    const HEIGHT       = 25;
    const MARGIN       = { top: 2, right: 8, bottom: 2, left: 5 };
    const INNER_WIDTH  = WIDTH - MARGIN.left - MARGIN.right;
    const INNER_HEIGHT = HEIGHT - MARGIN.top - MARGIN.bottom;
    const DATA_COUNT   = 30;
    let data           = [];

    const chart  = d3.select(`#${id}`)
        .selectAll('svg')
        .data([0])
        .join(
            enter => enter
                .append('svg')
                .attr('width', WIDTH)
                .attr('height', HEIGHT)
                .append('g')
                .attr('transform', 'translate(' + MARGIN.left + ',' + MARGIN.top + ')'),
        )

    if (updatedValue) {
        // Get existind data from the binding
        const existingData = chart.selectAll('path').data();

        // Push it on to the stack
        existingData[0].push(+updatedValue);

        // Redraw
        data = existingData[0];
    }
    else {
        data = d3.range(DATA_COUNT).map( d => Math.random() * 10 );
    }

    const x    = d3.scaleLinear().domain([0, data.length]).range([0, INNER_WIDTH]);
    const y    = d3.scaleLinear().domain([0, 10]).range([INNER_HEIGHT, 0]);

    // https://bl.ocks.org/d3noob/1cdce25b22e85e2b71dc291e2b4f2b39 (curve types)
    const line = d3.line().curve(d3.curveStep).x((d, i) => x(i)).y(d => y(d));

    // Use the new D3 v7 join pattern to have fine grained control of enters and updates
    chart.selectAll('path')
        .data([data])
        .join(
            enter => enter
                .append('path')
                .attr('fill', 'none')
                .attr('stroke', '#bbb')
                .attr('stroke-width', 1)
                .attr('d', line),
            update => update
                .transition()
                .duration(1000)
                .attr('d', line)
        )

    // Draw end caps
    chart.selectAll('.start')
        .data([data])
        .join(
            enter => enter
                .append('circle')
                .attr('r', 2)
                .attr('cx', x(0))
                .attr('cy', y(data[0]))
                .attr('class', 'start')
                .attr('fill', 'steelblue'),
            update => update
                .attr('cx', x(0))
                .attr('cy', y(data[0]))
        )

    chart.selectAll('.end')
        .data([data])
        .join(
            enter => enter.append('circle')
                .attr('r', 2)
                .attr('cx', x(data.length - 1))
                .attr('cy', y(data[data.length - 1]))
                .attr('class', 'end')
                .attr('fill', 'tomato'),
            update => update
                .attr('cx', x(data.length - 1))
                .attr('cy', y(data[data.length - 1]))
        )

}