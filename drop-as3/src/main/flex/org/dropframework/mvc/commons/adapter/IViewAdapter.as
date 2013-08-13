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
package org.dropframework.mvc.commons.adapter
{
    import flash.display.DisplayObject;


    /**
     * Wrapping adapter over the DisplayObject which provides on demand events listening functionality.
     *
     * @author jdanilov
     * */
    public interface IViewAdapter
    {
        /**
         * Applies the given DisplayObject as a view to wrap.
         */
        function set view (value : DisplayObject) : void;


        /**
         * Returns the DisplayObject wrapped by the Adapter.
         * */
        function get view () : DisplayObject;


        /**
         * Binds specified listener(s) to the actionNames of the dispatched ViewEvents.
         *
         * @param actionNames either array of action names or action name to call supplied listener for.
         * @param listener listener to call with the events of supplied actionNames.
         * */
        function on
                (actionNames : Object /* Array<String> or String */,
                 listener : Function /* (event : ViewEvent) */) : void;


        /**
         * Binds specified listener to all actions dispatched by View but not mapped to any listener.
         *
         * @param listener listener to call with the events of unmapped actionNames.
         * */
        function onUnmappedAction
                (listener : Function  /* (event : ViewEvent) */) : void;
    }
}