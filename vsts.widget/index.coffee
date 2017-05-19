personalAccessToken = '<personal-access-token>'
instance = '<instance>'
project = '<project-name>'
queryId = '<query-id>'

refreshFrequency: '5m'

command: 'vsts.widget/vsts.py '  + personalAccessToken + ' ' + instance + ' ' + project + ' ' + queryId

style: """
  top:  15px
  left: 15px
  color: #fff
  font-family: 'Helvetica Neue'
  font-size: 14px
  color: rgba(255,255,255,.8)
  background rgba(#000, .5)
  border-radius 5px
  padding: 10px
  width: 350px

  h1
    text-transform: uppercase
    font-size: 14px
    font-weight: 600
    color: #fff

  .items
    .item
        font-weight: 400

        .project
            display: inline-block
            width: 25%
            white-space:nowrap
            overflow:hidden
            text-overflow:ellipsis

        .title
            display: inline-block
            white-space:nowrap
            overflow:hidden
            text-overflow:ellipsis
            width: 65%

        .link
            display: inline-block
            width: 5%
            vertical-align: middle
            float: right

            svg
                float: right
               
                path
                    fill: #fff
"""

render: (_) -> """
    <div class="output">
        <h1>Work items:</h1>
        <div class="items"></div>
    </div>
"""

update: (output, domEl) ->
    data = JSON.parse(output)
    console.log(data)

    htmlItems = $(domEl).find('.items')
    
    htmlItems.html ''

    renderWorkItem = (project, title, link) -> """
        <div class="item">
            <span class="project">#{ project }</span>
            <span class="title">#{ title }</span>
            <span class="link">
                <a href="#{ link }">
                    <svg xmlns="http://www.w3.org/2000/svg" width="14px" height="14px" viewBox="0 0 100 100">
                        <path d="M50.433,0.892c-27.119,0-49.102,21.983-49.102,49.102s21.983,49.103,49.102,49.103s49.101-21.984,49.101-49.103S77.552,0.892,50.433,0.892z M59,79.031C59,83.433,55.194,87,50.5,87S42,83.433,42,79.031V42.469c0-4.401,3.806-7.969,8.5-7.969s8.5,3.568,8.5,7.969V79.031z M50.433,31.214c-5.048,0-9.141-4.092-9.141-9.142c0-5.049,4.092-9.141,9.141-9.141c5.05,0,9.142,4.092,9.142,9.141C59.574,27.122,55.482,31.214,50.433,31.214z"/>
                    </svg>
                </a>
            </span>
        </div>
    """

    if data.items
        for workItem in data.items
            if workItem.fields['System.WorkItemType'].toLowerCase() ==  'task'
                workItem.link = 'https://' + instance + '.visualstudio.com/' + workItem.fields['System.TeamProject'] + '/_workitems?id=' + workItem.id
                htmlItems.append renderWorkItem(workItem.fields['System.TeamProject'],
                                                workItem.fields['System.Title'],
                                                workItem.link)
    else
        htmlItems = '<div class="item"><span class="error">' + data.error + '</span></div>'
