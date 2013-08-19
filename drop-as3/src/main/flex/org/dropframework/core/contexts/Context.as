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
package org.dropframework.core.contexts
{

    import flash.utils.describeType;

    import org.dropframework.core.actors.IConcernedActor;
    import org.dropframework.core.commons.DropFrameworkError;


    /**
     * Default IContext interface implementation. Provides actors registering and lookup capabilities.
     *
     * Instantiate this class within your application and register all actors in.
     *
     * @author jdanilov
     * */
    public class Context implements IContext
    {
        protected var actors        : Vector.<IConcernedActor>;
        protected var actorsMapping : Vector.<Entry>;


        /**
         * Creates new empty Context's instance.
         */
        public function Context () : void
        {
            this.actors        = new Vector.<IConcernedActor>();
            this.actorsMapping = new Vector.<Entry>();
        }



        public function register (actor : IConcernedActor) : void
        {
            // actor can not be added twice
            if (actors.indexOf(actor) != -1)
                return;

            // we add actor, and update types mapping straight ahead
            actors.push(actor);
            for each (var entry : Entry in actorsMapping)
            {
                if (actor is entry.type as Class)
                {
                    entry.actors.push(actor);
                }
            }
        }


        public function remove (actor : IConcernedActor) : void
        {
            var index : int = actors.indexOf(actor);

            // if controller not found we simply do nothing
            if (index == -1)
                return;

            // we remove an actor, and update types mapping straight ahead
            actors = actors.splice(index, 1);
            for each (var entry : Entry in actorsMapping)
            {
                if (actor is entry.type)
                {
                    entry.actors =
                            (entry.actors as Array).splice((entry.actors as Array).indexOf(actor), 1);
                }
            }
        }


        public function call (type : Class, callbackOrArgs : Object /* (c : type) */ = null) : void
        {
            var c : Object;
            if (callbackOrArgs && callbackOrArgs is Function)
            {
                for each (c in arrayOf(type))
                {
                    (callbackOrArgs as Function)(c);
                }
            }
            else
            {
                var xml : XML = describeType(type);
                var list : XMLList = xml.factory.method;
                var names : Vector.<String> = new Vector.<String>();
                for each (var method : * in list)
                {
                    names.push(method.attribute('name'));
                }
                for each (var name : String in names)
                {
                    for each (c in arrayOf(type))
                    {
                        c[name].apply(null, callbackOrArgs);
                    }
                }
            }
        }


        public function instanceOf (type : Class) : IConcernedActor /* of type */
        {
            var result : Array = arrayOf(type);

            if (result.length == 0)
                return null;

            if (result.length > 1)
                throw new DropFrameworkError("More than one Actor found for type '" + type + "'");

            return result[0] as IConcernedActor;
        }


        protected function arrayOf (type : Class) : Array /* <type> */
        {
            // we start looking for the type in the mapping
            for each (var entry : Entry in actorsMapping)
            {
                if (entry.type == type)
                {
                    return entry.actors.slice();
                }
            }

            // if mapping not found we aggregate all actors of the same type...
            var result : Array = [];
            for each (var c : IConcernedActor in actors)
            {
                if (c is type)
                {
                    result.push(c);
                }
            }

            // ... and add a new entry in the mapping
            actorsMapping.push(new Entry(type, result));

            return result;
        }
    }
}


class Entry
{
    internal var type : Class;
    internal var actors : Array;

    public function Entry (type : Class, actors : Array)
    {
        this.type = type;
        this.actors = actors;
    }
}