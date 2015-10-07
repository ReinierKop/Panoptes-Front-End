React = require 'react'
BoardPreview = require './board-preview'
ActiveUsers = require './active-users'
talkClient = require '../api/talk'
PromiseRenderer = require '../components/promise-renderer'
Moderation = require './lib/moderation'
ProjectLinker = require './lib/project-linker'
ROLES = require './lib/roles'
{Link} = require '@edpaget/react-router'
CreateSubjectDefaultButton = require './lib/create-subject-default-button'
CreateBoardForm = require './lib/create-board-form'
Loading = require '../components/loading-indicator'
PopularTags = require './popular-tags'
{sugarClient} = require '../api/sugar'
ZooniverseTeam = require './lib/zoo-team'
alert = require '../lib/alert'
AddZooTeamForm = require './add-zoo-team-form'
DragReorderable = require 'drag-reorderable'

store = require '../store'
{connect} = require 'react-redux'
{get} = require '../actions'

mapStateToProps = (state) ->
  boards: state.boards

module?.exports = connect(mapStateToProps) React.createClass
  displayName: 'TalkInit'

  propTypes:
    section: React.PropTypes.string # 'zooniverse' for main-talk, 'project_id' for projects
    boards: React.PropTypes.array
    loading: React.PropTypes.bool

  getInitialState: ->
    loading: false
    moderationOpen: false

  componentWillMount: ->
    sugarClient?.subscribeTo('zooniverse') if @props.section is 'zooniverse'
    @dispatchBoards()

  dispatchBoards: ->
    store.dispatch(get({type: 'boards', params: {section: @props.section}}))

  componentWillReceiveProps: (nextProps) ->
    if @props.user isnt @props.user
      @dispatchBoards()

  componentWillUnmount: ->
    sugarClient?.unsubscribeFrom('zooniverse') if @props.section is 'zooniverse'

  boardPreview: (data, i) ->
    <BoardPreview {...@props} key={i} data={data} />

  boardOrders: ->
    <DragReorderable
      tag='ul'
      className='talk-reorder-boards'
      items={@state.boards}
      render={@boardOrderItem}
      onChange={@boardOrderChanged}
    />

  boardOrderItem: (board, i) ->
    <li key={board.id}>
      <i className="fa fa-bars bars" />{board.title}
    </li>

  boardOrderChanged: (boards) ->
    @setState boards: boards
    @updateBoardOrder(boards).then =>
      @setBoards()

  updateBoardOrder: (boards) ->
    boardsById = { }
    boardsById[board.id] = board for board in boards

    idsBefore = (board.id for board in @state.boards)
    idsAfter = (board.id for board in boards)

    changes = { }
    changes[id] = i for id, i in idsAfter when id isnt idsBefore[i]

    return Promise.resolve() if changes.length < 1
    Promise.all Object.keys(changes).map (id) =>
      boardsById[id].update(position: changes[id]).save()

  clearBoardOrder: ->
    Promise.all @state.boards.map (board) =>
      board.update(position: 0).save()
    .then =>
      @setState loading: true
      @setBoards()

  render: ->
    <div className="talk-home">
      {if @props.user?
        <div className="talk-moderation">
          <Moderation user={@props.user} section={@props.section}>
            <button onClick={=> @setState moderationOpen: !@state.moderationOpen}>
              <i className="fa fa-#{if @state.moderationOpen then 'close' else 'warning'}" /> Moderator Controls
            </button>
          </Moderation>

          {if @state.moderationOpen
            <div className="talk-moderation-children talk-module">
              <h2>Moderator Zone:</h2>

              {if @props.section isnt 'zooniverse'
                <CreateSubjectDefaultButton
                  section={@props.section}
                  onCreateBoard={@dispatchBoards} />
                }

              <ZooniverseTeam user={@props.user} section={@props.section}>
                <button className="link-style" type="button" onClick={=> alert (resolve) -> <AddZooTeamForm/>}>
                  Invite someone to the Zooniverse team
                </button>
              </ZooniverseTeam>

              <Link
                to="#{if @props.section isnt 'zooniverse' then 'project-' else ''}talk-moderations"
                params={
                  if (@props.params?.owner and @props.params?.name)
                    {owner: @props.params.owner, name: @props.params.name}
                  else
                    {}
                }>
                View Reported Comments
              </Link>

<<<<<<< HEAD
              <CreateBoardForm section={@props.section} onSubmitBoard={=> @setBoards()}/>

              <h3>Reorder Boards:</h3>
              {@boardOrders()}
              <button onClick={@clearBoardOrder}>Order by activity</button>
=======
              <CreateBoardForm section={@props.section} onSubmitBoard={=> setBoards(@props.section)}/>
>>>>>>> Remove old boards setter
            </div>
            }
        </div>
        }

      <div className="talk-list-content">
        <section>
          {if @state.loading
            <Loading />
           else if @props.boards?.length is 0
            <p>There are currently no boards.</p>
           else if @props.boards?.length
             @props.boards.map(@boardPreview)} 
        </section>

        <div className="talk-sidebar">
          <h2>Talk Sidebar</h2>

          <ProjectLinker user={@props.user} />

          <section>
            <PopularTags
              header={<h3>Popular Tags:</h3>}
              section={@props.section}
              params={@props.params} />
          </section>

          <section>
            <ActiveUsers section={@props.section} />
          </section>

          <section>
            <h3>
              {if @props.section is 'zooniverse'
                <Link className="sidebar-link" to="talk-recents" {...@props}>Recent Comments</Link>
              else
                <Link className="sidebar-link" to="project-talk-recents" {...@props}>Recent Comments</Link>
              }
            </h3>
          </section>
        </div>
      </div>
    </div>
