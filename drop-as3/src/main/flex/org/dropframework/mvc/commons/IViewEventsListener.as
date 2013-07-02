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
package org.dropframework.mvc.commons
{

    /**
     * Listens for ViewEvents dispatched on a displayObject.
     *
     * @author jdanilov
     * */
    public interface IViewEventsListener
    {
        /**
         * Binds specified listener to the actionNames of the dispatched ViewEvents.
         *
         * @param actionNames array of action names to call supplied listener for.
         * @param listener listener to call with the events of supplied actionNames.
         * */
        function onActions (actionNames : Array /* <String> */, listener : Function /* (event : ViewEvent) */) : void;


        /**
         * Binds specified listener to all unmapped actions.
         *
         * @param listener listener to call with the events of unmapped actionNames.
         * */
        function onUnmappedActions (listener : Function  /* (event : ViewEvent) */) : void;
    }
}