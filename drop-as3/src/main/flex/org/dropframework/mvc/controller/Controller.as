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
package org.dropframework.mvc.controller
{

    import org.dropframework.core.contexts.IContext;
    import org.dropframework.core.actors.ContextAwareActor;


    /**
     * Simple extension of the ContextAwareActor class which encapsulates the specific business layer logic of the
     * application.
     *
     * Designed for extension by subclasses.
     *
     * @author jdanilov
     * */
    public class Controller extends ContextAwareActor
    {
        /**
         * Creates new Controller. Automatically registers itself in the context.
         *
         * @param context - context to be used by the controller.
         * */
        public function Controller
                (context : IContext)
        {
            super(context);
        }
    }
}