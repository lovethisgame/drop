/*
 * Copyright 2013 Drop Framework Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package org.dropframework.mvc.commons.events
{

    import flash.events.Event;


    /**
     * Dynamic event, dispatched by View routed to Mediator via ViewAdapter.
     *
     * Event has only one type - ACTION, and is always created with this type in place. To differentiate events an
     * actionName field is used instead. This field is always supplied via constructor or static factory methods.
     *
     * @author jdanilov
     * */
    public dynamic class ViewEvent extends Event
    {
        public static const ACTION : String
                = "org.dropframework.mvc.commons.events.ViewEvent.ACTION";


        private static var uniqueId : uint = 0;


        /* Name of the action */
        private var _actionName : String = null;

        /* Instance of the parent event */
        private var _parentEvent : Event = null;



        /**
         * Creates a new ViewEvent for a gives set of arguments, equals to those of Event class but with one
         * special field - actionEvent.
         *
         * @param actionName name of the action occurred in the View.
         * @param parentEvent same as for Event class.
         * @param bubbles same as for Event class.
         * @param cancelable same as for Event class.
         */
        public function ViewEvent
                ( actionName : String,
                  parentEvent : Event   = null,
                  bubbles     : Boolean = false,
                  cancelable  : Boolean = false )
        {
            super(ACTION, bubbles, cancelable);

            this._parentEvent = parentEvent;
            this._actionName = actionName;
        }


        /**
         * Name of the action occurred in the View.
         * */
        public function get actionName () : String
        {
            return _actionName;
        }


        /**
         * Content of the ViewEvent in case it was supplied via ofContent factory method.
         */
        public function get content () : Object
        {
            if (this.hasOwnProperty("_content"))
                return this._content;

            return null;
        }


        /**
         * Parent event of the action.
         * */
        public function get parentEvent () : Event
        {
            return _parentEvent;
        }



        /**
         * Creates an instance of the ViewEvent. Equal to calling constructor directly.
         *
         * @param actionName name of the action occurred in the View.
         * @param parentEvent same as for Event class.
         * @param bubbles same as for Event class.
         * @param cancelable same as for Event class.
         *
         * @return instance of the ViewEvent for a given set of parameters.
         */
        public static function of
                ( actionName : String,
                  parentEvent : Event   = null,
                  bubbles     : Boolean = false,
                  cancelable  : Boolean = false ) : ViewEvent
        {
            return new ViewEvent(actionName, parentEvent, bubbles, cancelable);
        }


        /**
         * Creates an instance of the ViewEvent additionally supplying the generic content field. Content field then
         * become available via content getter on the ViewEvent instance.
         *
         * @param actionName name of the action occurred in the View.
         * @param content a content set on the ViewEvent.
         * @param parentEvent same as for Event class.
         * @param bubbles same as for Event class.
         * @param cancelable same as for Event class.
         *
         * @return instance of the ViewEvent for a given set of parameters.
         */
        public static function ofContent
                ( actionName : String,
                  content    : Object,
                  parentEvent : Event   = null,
                  bubbles     : Boolean = false,
                  cancelable  : Boolean = false ) : ViewEvent
        {
            var result : ViewEvent
                    = new ViewEvent(actionName, parentEvent, bubbles, cancelable);
            // noinspection JSUndefinedPropertyAssignment
            result._content = content;
            return result;
        }


        /**
         * Creates a true unique name of the action so there are no two similar actionNames on a system.
         *
         * @param actionName the human readable actionName to create unique name for.
         *
         * @return a unique actionName.
         */
        public static function uniqueName (actionName : String = null) : String
        {
            if (actionName == null)
                return String(uniqueId++);

            return actionName + ":" + uniqueId++;
        }
    }
}