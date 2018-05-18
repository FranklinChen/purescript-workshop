module HackerReader.Main where

import Prelude hiding (div)

import CSS (marginBottom, px)
import Control.Monad.Aff (Aff)
import Control.Monad.Aff.Console (log)
import Control.Monad.Eff (Eff)
import Data.Array as Array
import Data.Either (Either(Left,Right))
import Data.Foldable (for_)
import Data.Maybe (Maybe(Just, Nothing))
import Data.String as Str
import Data.Tuple (Tuple(Tuple))
import HackerReader.HackerNewsApi (Story, fetchHackerNewsStories)
import HackerReader.Styles as Styles
import Pux as Pux
import Pux.DOM.Events (onClick, onInput, targetValue)
import Pux.DOM.HTML (HTML)
import Pux.DOM.HTML.Attributes (key, style)
import Pux.Renderer.React (renderToDOM)
import Signal (constant)
import Text.Smolder.HTML (a, div, h1, input, span)
import Text.Smolder.HTML.Attributes (href, value)
import Text.Smolder.Markup (text, (!), (#!))

data Event
  = LoadFrontPage
  | SetStories (Array Story)
  | SetSortBy SortBy
  | SetFilter String

data SortBy = ByScore | ByTime

type State =
  { filterText :: String
  , selectedSort :: SortBy
  , stories :: Array Story }

foreign import formatTime :: String -> String

initialState :: State
initialState =
  { filterText: ""
  , selectedSort: ByScore
  , stories: [] }

foldp :: Event -> State -> { state :: State, effects :: Array (Aff _ (Maybe Event)) }
foldp (LoadFrontPage) state = { state, effects: [loadHackerNewsStories] }
foldp (SetStories stories) state = { state: newState, effects: [] }
  where newState = state { stories = stories }
foldp (SetSortBy newSort) state = { state: newState, effects: [] }
  where newState = state { selectedSort = newSort }
foldp (SetFilter filterText) state = { state: newState , effects: [] }
  where newState = state { filterText = filterText }

loadHackerNewsStories :: Aff _ (Maybe Event)
loadHackerNewsStories = do
  storiesResult <- fetchHackerNewsStories
  case storiesResult of
    Left errors -> do
      log $ "Error decoding JSON: " <> show errors
      pure Nothing
    Right stories -> pure $ Just (SetStories stories)

view :: State -> HTML Event
view {filterText, selectedSort, stories} = do
  div ! style Styles.header $ do
    h1
      ! style Styles.headerTitle
      $ text "Hacker Reader"
    input
      #! onInput (\e -> SetFilter (targetValue e))
      ! value filterText
      ! style Styles.filter
  div ! style Styles.sort $ do
    div ! style (sortItemStyle ByScore)
      #! onClick (\_ -> SetSortBy ByScore)
      $ text "Sort by score"
    div ! style (sortItemStyle ByTime)
      #! onClick (\_ -> SetSortBy ByTime)
      $ text "Sort by date"
  div ! style Styles.content $ do
    for_ sortedStories storyItem
  where
    filteredStories = Array.filter (storyContainsText filterText) stories
    storiesWithRank = Array.zip (Array.range 1 (Array.length stories + 1)) filteredStories
    sortedStories = Array.sortBy (storySort selectedSort) storiesWithRank
    sortItemStyle sort =
      if isSortSelected selectedSort sort
         then Styles.selected
         else Styles.unselected

storyContainsText :: String -> Story -> Boolean
storyContainsText "" _ = true
storyContainsText filterText {title} = Str.contains (Str.Pattern filterText) (Str.toLower title)
      
isSortSelected :: SortBy -> SortBy -> Boolean
isSortSelected ByTime ByTime = true
isSortSelected ByScore ByScore = true
isSortSelected _ _ = false

storySort :: SortBy -> Tuple Int Story -> Tuple Int Story -> Ordering
storySort ByTime (Tuple _ {created_at: time1}) (Tuple _ {created_at: time2}) = time2 `compare` time1
storySort ByScore (Tuple _ {points: points1}) (Tuple _ {points: points2}) = points2 `compare` points1

storyItem :: Tuple Int Story -> HTML Event
storyItem (Tuple rank story) =
  div ! style (marginBottom (px 5.0)) ! key story.objectID $ do
    div ! style Styles.rank $ text (show rank <> ".")
    a ! href story.url $ text story.title
    div do
      div ! style Styles.points $ text (show story.points <> " points")
      divider
      div ! style Styles.author $ text story.author
      divider
      div ! style Styles.numComments $ text (show story.num_comments <> " comments")
      divider
      div ! style Styles.numComments $ text (formatTime story.created_at)

divider :: HTML Event
divider = span ! style Styles.divider $ text "|"
  
main :: Eff _ Unit
main = do
  app <- Pux.start
    { initialState
    , view
    , foldp
    , inputs: [constant LoadFrontPage]
    }
  renderToDOM "#app" app.markup app.input