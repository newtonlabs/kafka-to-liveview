import * as d3 from "../vendor/d3.min"

const WIDTH        = 200;
const HEIGHT       = 25;
const MARGIN       = { top: 2, right: 2, bottom: 2, left: 2 };
const INNER_WIDTH  = WIDTH - MARGIN.left - MARGIN.right;
const INNER_HEIGHT = HEIGHT - MARGIN.top - MARGIN.bottom;
const DATA_COUNT   = 40;
const ANIMATION_T  = 200;

export function mountSparkline(id) {
    const chart  = d3.select(`#${id}`)
        .append('svg')
        .attr('width', WIDTH)
        .attr('height', HEIGHT)

    chart.append('g')
        .attr('transform', 'translate(' + MARGIN.left + ',' + MARGIN.top + ')');
    
    const y = d3.scaleLinear().domain([0, 11]).range([INNER_HEIGHT, 0]);
    const x = d3.scaleLinear().domain([0, DATA_COUNT]).range([0, INNER_WIDTH]);

    const defs = chart.append("defs")

    defs.append("clipPath")
        .attr("id", `clip${id}`)
        .append("rect")
        .attr("width", x(DATA_COUNT - 2))
        .attr("height", HEIGHT)
    
    defs.append("linearGradient")
        .attr("id", `linegradient${id}`)
        .attr("gradientUnits", "userSpaceOnUse")
        .attr("x1", 0)
        .attr("y1", y(0))
        .attr("x2", 0)
        .attr("y2", y(2)) // Favorite vs Underdog
        .selectAll("stop")
            .data([
            {offset: "70%", color: "#EEA65D"},
            {offset: "100%", color: "#bfdbfe"}
            ])
        .enter().append("stop")
            .attr("offset", function(d) { return d.offset; })
            .attr("stop-color", function(d) { return d.color; });
}


export function sparkline(id, updatedValue) {
    // Get existing data, and update it (will create random if not present)
    const chart = d3.select(`#${id} g`);

    let data = chart.selectAll('path').data();
    data = updateData(updatedValue, data, DATA_COUNT);

    // TODO this 11 needs to be a passed value based on data ranges using extent
    const y = d3.scaleLinear().domain([0, 11]).range([INNER_HEIGHT, 0]);
    const x = d3.scaleLinear().domain([0, data.length]).range([0, INNER_WIDTH]);

    // https://bl.ocks.org/d3noob/1cdce25b22e85e2b71dc291e2b4f2b39 (curve types)
    const line = d3.line().curve(d3.curveLinear).x((d, i) => x(i)).y(d => y(d));

    // Use the new D3 v7 join pattern to have fine grained control of enters and updates
    // https://observablehq.com/@d3/easing-animations
    chart.selectAll('path')
        .data([data])
        .join(
            enter => enter
                .append("g")
                .attr("clip-path", `url(#clip${id})`)
                .append('path')
                .attr('fill', 'none')
                .attr("stroke", `url(#linegradient${id})`)
                .attr('stroke-width', 1)
                .attr('d', line)
                .attr("transform", "translate(" + x(-1) + ",0)"),
            update => update
                .attr('d', line)
                .attr("transform", null)
                .transition()
                .ease(d3.easeLinear)
                .duration(ANIMATION_T)
                .attr("transform", "translate(" + x(-1) + ",0)")
        )

    // Draw end caps
    chart.selectAll('.start')
        .data([data])
        .join(
            enter => enter
                .append('circle')
                .attr('r', 2)
                .attr('cx', x(0))
                .attr('cy', y(data[1]))
                .attr('class', 'start')
                .attr('fill', '#054c96'),
                // .attr("fill", `url(#linegradient${id})`),
            update => update
                .transition()
                .ease(d3.easeLinear)
                .duration(ANIMATION_T)
                .attr('cx', x(0))
                .attr('cy', y(data[1]))
        )

    chart.selectAll('.end')
        .data([data])
        .join(
            enter => enter.append('circle')
                .attr('r', 2)
                .attr('cx', x(data.length - 2))
                .attr('cy', y(data[data.length - 1]))
                .attr('class', 'end')
                .attr('fill', '#c3023a'),
                // .attr("fill", `url(#linegradient${id})`),
            update => update
                .transition()
                .ease(d3.easeLinear)
                .duration(ANIMATION_T)
                .attr('cx', x(data.length - 2))
                .attr('cy', y(data[data.length - 1]))
        )

}


function updateData(updatedValue, data, DATA_COUNT) {
    if (updatedValue) {
        data[0].push(+updatedValue);
        return data[0].splice(1);
    }
    else {
        return d3.range(DATA_COUNT).map( d => Math.random() * 10 );
    }
}